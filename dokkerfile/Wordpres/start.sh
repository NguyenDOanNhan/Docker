#!/bin/bash

/etc/init.d/mysql restart
mysql -e "CREATE DATABASE wordpress_db;"
mysql -e "CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED  BY  '${PASSWORD}';"
mysql -e "GRANT ALL ON wordpress_db.* TO '${USER_NAME}'@'localhost'"
mysql -e "FLUSH PRIVILEGES;"
sed -i -e "s/database_name_here/wordpress_db/g" /var/www/html/wp-config.php
sed -i -e "s/username_here/${USER_NAME}/g" /var/www/html/wp-config.php
sed -i -e "s/password_here/${PASSWORD}/g" /var/www/html/wp-config.php
apache2ctl -D FOREGROUND
