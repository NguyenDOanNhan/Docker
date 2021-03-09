#!/bin/bash
php-fpm
ln -sf /usr/share/zoneinfo/${TZ}  /etc/localtime
sed -i -e "s/database_name_here/${DATABASE_NAME}/" /var/www/wordpress/wp-config.php
sed -i -e "s/username_here/${DATABASE_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/password_here/${DATABASE_PASSWORD_USER}/" /var/www/wordpress/wp-config.php
mysql_install_db --user=mysql --ldata=/var/lib/mysql
nohup /usr/libexec/mysqld --user=root &
sleep 5
mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('${PASSWORD_ROOTMYSQL}');FLUSH PRIVILEGES;"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE DATABASE ${DATABASE_NAME};"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD_USER}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD_USER}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "FLUSH PRIVILEGES;"
nginx -g 'daemon off;'
