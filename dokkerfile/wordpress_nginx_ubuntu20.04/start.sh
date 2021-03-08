#!/bin/bash
/etc/init.d/php7.4-fpm start
/etc/init.d/mysql start
sed -i -e "s/database_name_here/${DATABASE_NAME}/" /var/www/wordpress/wp-config.php
sed -i -e "s/username_here/${DATABASE_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/password_here/${DATABASE_PASSWORD_USER}/" /var/www/wordpress/wp-config.php

mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE DATABASE ${DATABASE_NAME};"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD_USER}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "FLUSH PRIVILEGES;"
nginx -g 'daemon off;'
