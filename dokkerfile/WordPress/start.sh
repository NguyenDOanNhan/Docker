#!/bin/bash
/etc/init.d/mysql restart
mysql -e "CREATE DATABASE wordpress_db;"
mysql -e "CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED  BY  '${PASS_WORD}';"
mysql -e "GRANT ALL ON wordpress_db.* TO '${USER_NAME}'@'localhost'"
mysql -e "FLUSH PRIVILEGES;"
sed -i -e "s/database_name_here/wordpress_db/g
s/username_here/${USER_NAME}/g
s/password_here/${PASS_WORD}/g" /var/www/html/wp-config.php
apache2ctl -D FOREGROUND
