FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
COPY apache-tomcat-9.0.45.tar.gz ~
COPY guacamole-server-1.2.0.tar.gz ~
COPY guacamole-1.2.0.war ~
COPY tomcat.service /etc/systemd/system/tomcat.service
COPY user-mapping.xml /etc/guacamole/user-mapping.xml
COPY start.sh /start.sh
RUN apt update && \
apt install -y software-properties-common tar nano make vim net-tools htop gcc vim curl wget g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev \
libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev build-essential \
libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev \
libssl-dev libvorbis-dev libwebp-dev
RUN add-apt-repository ppa:remmina-ppa-team/freerdp-daily \
&& apt update \
&& apt install freerdp2-dev freerdp2-x11 -y \
&& apt install openjdk-8-jdk openjdk-8-jre -y\
&& echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> /etc/environment \
&& echo 'JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre' >> /etc/environment \
&& useradd -m -U -d /opt/tomcat -s /bin/false tomcat
# && tar -xzf apache-tomcat-9.0.45.tar.gz -C /opt/tomcat/ \
# && mv /opt/tomcat/apache-tomcat-9.0.45 /opt/tomcat/tomcatapp \
# && chown -R tomcat: /opt/tomcat \
# && chmod +x /opt/tomcat/tomcatapp/bin/*.sh \
# && tar xzf ~/guacamole-server-1.2.0.tar.gz \
# && cd ~/guacamole-server-1.2.0 \
# && ./configure --with-init-dir=/etc/init.d \
# && make \
# && make install \
# && ldconfig \
# && mkdir /etc/guacamole \
# && mv ~/guacamole-1.2.0.war /etc/guacamole/guacamole.war \
# && echo "GUACAMOLE_HOME=/etc/guacamole" | tee -a /etc/default/tomcat \
# && ln -s /etc/guacamole /opt/tomcat/tomcatapp/.guacamole
EXPOSE 8080 22 4822

CMD ["/bin/bash","start.sh"]