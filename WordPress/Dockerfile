#Build image ubuntu:20.04
FROM ubuntu
# Disable timezone
ENV DEBIAN_FRONTEND=noninteractive \
USER_NAME=wordpress \
PASS_WORD=mypassword
ADD https://wordpress.org/latest.tar.gz /tmp
ADD ./start.sh /start.sh
# Build
RUN sed -i -e 's\archive.ubuntu.com\mirrors.bkns.vn\g' /etc/apt/sources.list \
&& apt update \
&& apt -y install apache2 \
&& apt -y install mysql-server \
&& apt-get -y install php7.4 php-mysql\
&& cd /tmp/ \
&& tar -zxvf latest.tar.gz \
&& mv wordpress/* /var/www/html/ \
&& chown -R www-data:www-data /var/www/html/ \
&& chmod -R 755 /var/www/html/ \
&& rm /var/www/html/index.html \
&& mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php \
&& chmod 755 /start.sh
CMD [ "/bin/bash","start.sh" ]
EXPOSE 80 443