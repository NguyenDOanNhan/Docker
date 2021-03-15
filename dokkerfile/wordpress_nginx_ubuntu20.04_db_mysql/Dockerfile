FROM ubuntu:20.04
ENV DATABASE_NAME=wordpress \
    DATABASE_USER=wordpress \
    DATABASE_PASSWORD_USER=wordpress\
    PASSWORD_ROOTMYSQL=root \
    DEBIAN_FRONTEND=noninteractive
ADD https://wordpress.org/latest.tar.gz /latest.tar.gz
ADD ./start.sh /start.sh
EXPOSE 80 3306
RUN apt update \
    && apt install curl net-tools expect mysql-server mlocate vim nano procps wget awscli tar -y \
    && apt install nginx -y \
    && apt install -y php7.4 \
    && tar xvf latest.tar.gz \
    && cp -r wordpress /var/www/wordpress \
    && chmod -R 777 /var/www/wordpress/* \
    && mv /var/www/wordpress/wp-config-sample.php   /var/www/wordpress/wp-config.php
RUN apt install -y php-fpm php-pear php-cgi php-common php-curl php-mbstring php-gd php-mysql php-bcmath php-json php-xml php-intl php-zip php-imap
ADD ./mysite.conf /etc/nginx/sites-available/mysite.conf
RUN mv /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-available/mysite \
    && ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/mysite \
    && rm /etc/nginx/sites-enabled/default
CMD ["/bin/bash", "start.sh"]