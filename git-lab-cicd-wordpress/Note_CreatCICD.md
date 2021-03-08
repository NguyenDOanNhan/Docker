# Thực hành
Tạo một project Gitlab
2 Máy server chữa apache+mysql; và có cài gitlab-runner
Yêu cầu:
+ 2 server dùng chung một sources code wordpress để tạo 2 trang wordpress khác nhau sử dụng CICD
+ Sử dụng chung file config wp-config-sample.php
+ Sử dụng CICD sao cho khi thay đổi code wordpress thì 2 server tự động peploy trang wordpress đúng

# Lưu ý:
**Cấu hình 2 máy runner trên Ubuntu 20.04**
+ git-lab-01 và git-lab-02:
	+ Đã cài đặt wordpress
	+ gitlab-runner 13.7 ( phải trên bản 12)
	+ OS: ubuntu 20.04;
+ 1 Project gitlab có sử dụng CI/CD
**DB:**

**info** 

```mysql  Ver 8.0.22-0ubuntu0.20.04.3 for Linux on x86_64 ((Ubuntu))```

**Install DB**
```
apt -y install mysql-server
```
**Create DB**
```
apt -y install mysql-server
mysql -e "CREATE DATABASE wordpress_db ;"
mysql -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED  BY  'mypassword';"
mysql -e "GRANT ALL ON wordpress_db.* TO 'wordpress'@'localhost'"
mysql -e "FLUSH PRIVILEGES;"
```
**Apache:**
> 
Server version: Apache/2.4.41 (Ubuntu)
Server built:   2020-08-12T19:46:17

How to Install apache
```
sudo apt install apache2 -y
systemctl enable apache2
systemctl start apache2
```
**PHP:**

**infor**
>
PHP 7.4.3 (cli) (built: Oct  6 2020 15:47:56) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
with Zend OPcache v7.4.3, Copyright (c), by Zend Technologies

**How to install php**
```apt-get -y install php7.4 php-mysql```
# Bước 1:
**Trong máy local**

[install gitlab-runner](https://docs.gitlab.com/runner/install/linux-repository.html)

Cài đặt gitlab-runner for ubuntu
```
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
export GITLAB_RUNNER_DISABLE_SKEL=true; sudo -E apt-get install gitlab-runner
```
**Edit file sudoers**

```sudo visudo -f /etc/sudoers```

Add user gitlab-runner

```gitlab-runner ALL=(ALL) NOPASSWD: ALL```
# Thiết định ở local các quyền cho user gitlab-runner
```
sudo -i
#thêm user gitlab-runner vào nhóm sudo để không cần hỏi pass khi gõ sudo
usermod -aG sudo gitlab-runner
#Chuyển chủ sở hữu cho user gitlab-runner
chown - R gitlab-runner:gitlab-runner /var/www/wordpress
chmod -R 775 /var/www/wordpress
```
# Bước 5 :
*File /etc/apache2/sites-available/000-default.conf*

```
	<VirtualHost *:80>
		ServerName mywordpressblog.com
		ServerAdmin nguyendoannhan@luvina.net
		DocumentRoot /var/www/wordpress/
		CustomLog /dev/null combined
		#LogLevel Debug
		ErrorLog /var/www/wordpress/error.log
		<Directory /var/www/wordpress/>
			Options -Indexes -ExecCGI +FollowSymLinks -SymLinksIfOwnerMatch
			DirectoryIndex index.php index.html
			Require all granted
			AllowOverride None
		</Directory>
	</VirtualHost>
```
# Bước 6 phía git

	
	