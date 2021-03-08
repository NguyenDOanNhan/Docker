FROM php:7.3-fpm

RUN apt update \
    && apt -y install libzip-dev zip\
    && docker-php-ext-install zip opcache mysqli pdo_mysql \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable opcache \
    && docker-php-ext-enable pdo_mysql
ADD ./php.ini /usr/local/etc/php/php.ini
EXPOSE 9000