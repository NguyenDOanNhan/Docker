FROM amazonlinux:2
ENV DATABASE_NAME=wordpress \
    DATABASE_USER=wordpress \
    DATABASE_PASSWORD_USER=wordpress\
    PASSWORD_ROOTMYSQL=root \
    TZ=Asia/Ho_Chi_Minh
ADD https://wordpress.org/latest.tar.gz /latest.tar.gz
ADD ./mysite.conf /etc/nginx/conf.d/mysite.conf
ADD ./start.sh /start.sh
EXPOSE 80 3306
CMD ["/bin/bash", "start.sh"]
RUN yum install curl net-tools expect mariadb-server mlocate vim procps wget aws-cli tar -y \
    && amazon-linux-extras install nginx1 -y \
    && amazon-linux-extras enable php7.4 \
    && yum install -y php php-{cli,fpm,pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,intl,zip,imap} \
    && sed -i -e "s/apache$/nginx/g" /etc/php-fpm.d/www.conf \
    && tar xvf latest.tar.gz \
    && cp -r wordpress /var/www/wordpress \
    && chmod -R 777 /var/www/wordpress/* \
    && mv /var/www/wordpress/wp-config-sample.php   /var/www/wordpress/wp-config.php