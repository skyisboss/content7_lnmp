#!bin/bash

RED='\033[01;31m'
RESET='\033[0m'
GREEN='\033[01;32m'
VERSION='1.0'
clear
echo -e "$GREEN*************************************************************$RESET"
echo -e "       CentOS 7 安装 LNMP 环境（PHP7.1 + MySQL5.7 + Nginx）- ${VERSION}  "
echo -e "                   Copyright (c) 2017 By skyisboss"
echo -e "$GREEN*************************************************************$RESET"
echo " "

echo  "If you need to cancell  the installation press Ctrl+C  ...."
echo -n  "Press ENTER to start the installation  ...."
read

#修改 yum 源
function stpe_1()
{
	rpm -Uvh epel-release-latest-7.noarch.rpm
	rpm -Uvh webtatic-release.rpm
	rpm -Uvh mysql57-community-release-el7-9.noarch.rpm
	yum -y install wget vim
}

#安装 Nginx、MySQL、PHP
function stpe_2()
{
	yum -y install nginx
	yum -y install mysql-community-server
	yum -y install php71w-devel php71w.x86_64 php71w-cli.x86_64 php71w-common.x86_64 php71w-gd.x86_64 php71w-ldap.x86_64 php71w-mbstring.x86_64 php71w-mcrypt.x86_64  php71w-pdo.x86_64   php71w-mysqlnd  php71w-fpm php71w-opcache php71w-pecl-redis php71w-pecl-mongo
}
function stpe_3()
{
	# 配置默认编码为 utf8
	echo 'character_set_server=utf8' >> /etc/my.cnf
	echo "init_connect='SET NAMES utf8'" >> /etc/my.cnf
	systemctl restart mysqld    # 重启 MySQL
	systemctl enable mysqld  #设置开机启动
}
# 修改 Nginx 配置
function stpe_4()
{
	# 调整防火墙规则的配置
	sed -i "s/^<\/zone>$/  <service name=\"nginx\"\/>\n<\/zone>/" /etc/firewalld/zones/public.xml
	systemctl reload firewalld

	# 修改 Nginx 配置
	mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf_tmp
	cp nginx.conf /etc/nginx/

	systemctl start nginx # 启动 Nginx
	systemctl enable nginx # 设置开机启动
	# 设置开机启动 php-fpm
	systemctl enable php-fpm
	systemctl start php-fpm
}
stpe_1
stpe_2
stpe_3
stpe_4


clear
echo -e ""
echo -e "${GREEN}install success.${RESET}"
echo -e ""
echo -e "$GREEN*************************************************************$RESET"
echo `php -v` | awk '{print $1$2}'
echo `mysql -V` | awk -F ',' '{print $1}'
nginx -v
echo -e 'mysql password:'`grep 'temporary password' /var/log/mysqld.log | awk -F 'localhost: ' '{print $2}'`


















