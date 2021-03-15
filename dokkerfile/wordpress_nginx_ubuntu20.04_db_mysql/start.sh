#!/bin/bash
/etc/init.d/php7.4-fpm start

sed -i -e "s/database_name_here/${DATABASE_NAME}/" /var/www/wordpress/wp-config.php
sed -i -e "s/username_here/${DATABASE_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/password_here/${DATABASE_PASSWORD_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
/etc/init.d/mysql start

mysql -e "UPDATE mysql.user SET PLUGIN='mysql_native_password' WHERE user='root';FLUSH PRIVILEGES;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASSWORD_ROOTMYSQL}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE DATABASE ${DATABASE_NAME};"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE USER '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD_USER}'; GRANT ALL ON *.* TO '${DATABASE_USER}'@'%' WITH GRANT OPTION ;"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE USER '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD_USER}'; GRANT ALL ON *.* TO '${DATABASE_USER}'@'localhost' WITH GRANT OPTION ;FLUSH PRIVILEGES;"

nginx -g 'daemon off;'
