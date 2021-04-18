#Guacamole
# Step 1: Server Preparation
sudo apt update
sudo apt install -y gcc vim curl wget g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev \
libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev build-essential \
libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev \
libssl-dev libvorbis-dev libwebp-dev

# Install FreeRDP2
sudo add-apt-repository ppa:remmina-ppa-team/freerdp-daily
sudo apt update
sudo apt install freerdp2-dev freerdp2-x11 -y
# Install JDK
sudo apt install openjdk-8-jdk openjdk-8-jre -y
cat >> /etc/environment <<EOL
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
EOL
#Step 2: Install Apache Tomcat

##Create Tomcat system user
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
##Fetch Apache Tomcat
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.45/bin/apache-tomcat-9.0.45.tar.gz -P ~

# check if not exist: sudo mkdir /opt/tomcat
cd ~
sudo tar -xzf apache-tomcat-9.0.45.tar.gz -C /opt/tomcat/
sudo mv /opt/tomcat/apache-tomcat-9.0.45 /opt/tomcat/tomcatapp
sudo chown -R tomcat: /opt/tomcat
sudo chmod +x /opt/tomcat/tomcatapp/bin/*.sh
sudo vim /etc/systemd/system/tomcat.service

##add contend:

[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/opt/tomcat/tomcatapp"
Environment="CATALINA_HOME=/opt/tomcat/tomcatapp"
Environment="CATALINA_PID=/opt/tomcat/tomcatapp/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/tomcatapp/bin/startup.sh
ExecStop=/opt/tomcat/tomcatapp/bin/shutdown.sh

[Install]
WantedBy=multi-user.target


## Then start the service
sudo systemctl daemon-reload
## And tomcat should be running happily
sudo systemctl enable --now tomcat
## check tomcat
systemctl status tomcat
## fireWall
sudo ufw allow 8080/tcp

Step 3: Build the Guacamole Server From Source

wget https://downloads.apache.org/guacamole/1.2.0/source/guacamole-server-1.2.0.tar.gz -P ~

tar xzf ~/guacamole-server-1.2.0.tar.gz
cd ~/guacamole-server-1.2.0
./configure --with-init-dir=/etc/init.d

make
sudo make install
sudo ldconfig
sudo systemctl daemon-reload
sudo systemctl start guacd
sudo systemctl enable guacd
systemctl status guacd

##Step 4: Install the Guacamole Web Application
#Install Guacamole Client on Ubuntu 20.04

sudo mkdir /etc/guacamole


wget https://downloads.apache.org/guacamole/1.2.0/binary/guacamole-1.2.0.war -P ~
sudo mv ~/guacamole-1.2.0.war /etc/guacamole/guacamole.war
## create a symbolic link of the guacamole client to Tomcat webapps directory as shown below

#Step 5: Configure Guacamole Server
## Create GUACAMOLE_HOME environment variable
echo "GUACAMOLE_HOME=/etc/guacamole" | sudo tee -a /etc/default/tomcat
## Create /etc/guacamole/guacamole.properties config file and populate is as shown
sudo vim /etc/guacamole/guacamole.properties
##add contend
guacd-hostname: localhost
guacd-port:    4822
user-mapping:    /etc/guacamole/user-mapping.xml
auth-provider:    net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping:    /etc/guacamole/user-mapping.xml


----
sudo ln -s /etc/guacamole /opt/tomcat/tomcatapp/.guacamole

#Step 6: Setup Guacamole Authentication Method
echo -n Nhan1996 | openssl md5
ouput (stdin)= b307ad0bb81b5aadb32af55f6d3977ff
sudo vim /etc/guacamole/user-mapping.xml

# add contend
<user-mapping>

<!-- Per-user authentication and config information -->

<!-- A user using md5 to hash the password
guacadmin user and its md5 hashed password below is used to
login to Guacamole Web UI-->
<authorize
username="nhannd"
password="b307ad0bb81b5aadb32af55f6d3977ff"
encoding="md5">

<!-- First authorized Remote connection -->
<connection name="RHEL 7 Maipo">
<protocol>ssh</protocol>
<param name="hostname">192.168.109.110</param>
<param name="port">22</param>
</connection>

<!-- Second authorized remote connection -->
<connection name="Windows Server 2019">
<protocol>rdp</protocol>
<param name="hostname">192.168.109.100</param>
<param name="port">3389</param>
<param name="username">Administrator</param>
<param name="ignore-cert">true</param>
</connection>

</authorize>

</user-mapping>

#---

sudo systemctl restart tomcat guacd
sudo ufw allow 4822/tcp
# Step 7: Getting Guacamole Web Interface
http://ip-or-domain-name:8080/guacamole
http://192.168.109.110:8080/guacamole
localhost:8080/guacamole

docker run --name guacadmin -dit -p 8080:8080 -p 4822:4822 -h guacadmin ubuntu:20.04

---
# Dockerfile
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
COPY apache-tomcat-9.0.45.tar.gz ~
COPY guacamole-server-1.2.0.tar.gz ~
COPY guacamole-1.2.0.war ~
COPY tomcat.service /etc/systemd/system/tomcat.service
COPY user-mapping.xml /etc/guacamole/user-mapping.xml
WORKDIR ~
RUN apt update && \
apt install -y software-properties-common nano make vim net-tools htop gcc vim curl wget g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev \
libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev build-essential \
libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev \
libssl-dev libvorbis-dev libwebp-dev
RUN printf "\n" | add-apt-repository ppa:remmina-ppa-team/freerdp-daily \
&& apt update \
&& apt install freerdp2-dev freerdp2-x11 -y \
&& apt install openjdk-8-jdk openjdk-8-jre -y\
&& echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> /etc/environment \
&& echo 'JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre' >> /etc/environment \
&& useradd -m -U -d /opt/tomcat -s /bin/false tomcat \
&& mkdir /opt/tomcat \
&& tar -xzf apache-tomcat-9.0.45.tar.gz -C /opt/tomcat/ \
&& mv /opt/tomcat/apache-tomcat-9.0.45 /opt/tomcat/tomcatapp \
&& chown -R tomcat: /opt/tomcat \
&& chmod +x /opt/tomcat/tomcatapp/bin/*.sh \
&& tar xzf ~/guacamole-server-1.2.0.tar.gz \
&& cd ~/guacamole-server-1.2.0 \
&& ./configure --with-init-dir=/etc/init.d \
&& make \
&& make install \
&& ldconfig \
&& mkdir /etc/guacamole \
&& mv ~/guacamole-1.2.0.war /etc/guacamole/guacamole.war \
&& echo "GUACAMOLE_HOME=/etc/guacamole" | tee -a /etc/default/tomcat \
&& ln -s /etc/guacamole /opt/tomcat/tomcatapp/.guacamole
EXPOSE 8080 22 4822

CMD ["/bin/bash","start.sh"]

start.sh
#!/bin/bash
nohup /opt/tomcat/tomcatapp/bin/catalina.sh run &
/etc/init.d/guacd start