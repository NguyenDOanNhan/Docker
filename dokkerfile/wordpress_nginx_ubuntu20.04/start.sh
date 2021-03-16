#!/bin/bash
/etc/init.d/php7.4-fpm start

sed -i -e "s/database_name_here/${DATABASE_NAME}/" /var/www/wordpress/wp-config.php
sed -i -e "s/username_here/${DATABASE_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/password_here/${DATABASE_PASSWORD_USER}/" /var/www/wordpress/wp-config.php
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
mysql_install_db --user=mysql --ldata=/var/lib/mysql
/etc/init.d/mysql start --user=root
mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('${PASSWORD_ROOTMYSQL}');FLUSH PRIVILEGES;"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "CREATE DATABASE ${DATABASE_NAME};"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'localhost' IDENTIFIED BY '${DATABASE_PASSWORD_USER}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "GRANT ALL PRIVILEGES ON *.* TO '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD_USER}';"
mysql -uroot -p${PASSWORD_ROOTMYSQL} -e "FLUSH PRIVILEGES;"

nginx -g 'daemon off;'
