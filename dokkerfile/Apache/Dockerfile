#Build image ubuntu:20.04
FROM ubuntu
# Disable timezone
ENV DEBIAN_FRONTEND=noninteractive \
USER_NAME=wordpress \
PASS_WORD=mypassword \
WORDPRESS_DB_NAME=wordpress_db
ADD https://wordpress.org/latest.tar.gz /tmp
# Build
RUN sed -i -e 's\archive.ubuntu.com\mirrors.bkns.vn\g' /etc/apt/sources.list \
&& apt update \
&& apt -y install apache2 \
&& cd /tmp/ \
&& tar -zxvf latest.tar.gz \
&& mv wordpress/* /var/www/html/ \
&& chown -R www-data:www-data /var/www/html/ \
&& chmod -R 755 /var/www/html/ \
&& rm /var/www/html/index.html \
&& mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php \
&& sed -i -e "s/database_name_here/${WORDPRESS_DB_NAME}/g" /var/www/html/wp-config.php \
&& sed -i -e "s/username_here/${USER_NAME}/g" /var/www/html/wp-config.php \
&& sed -i -e "s/password_here/${PASS_WORD}/g" /var/www/html/wp-config.php
CMD ["/usr/sbin/apache2","-D","FOREGROUND"]
EXPOSE 80 443