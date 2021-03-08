FROM httpd:latest
ADD https://wordpress.org/latest.tar.gz /tmp
ADD ./httpd.conf /usr/local/apache2/conf/httpd.conf
ADD ./httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

RUN apt-get update -y \
    && mkdir -p /var/www/html \
    && cd /tmp/ \
    && tar -zxvf latest.tar.gz \
    && cp -r wordpress/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/ \
    && mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
ADD ./wp-config.php  /var/www/html/wp-config.php

EXPOSE 80 443
CMD [ "httpd-foreground"]