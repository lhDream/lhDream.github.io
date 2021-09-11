#!/bin/bash
# https://blog.csdn.net/qq_41054313
#数据库密码
mysqlPWD="lhDream@123"

echo "--MySQL5.7安装--"

echo "下载依赖环境"
yum -y install wget
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm

echo "开始安装"
yum -y install mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql-community-server

echo "启动MySQL"
systemctl start  mysqld.service
systemctl status mysqld.service
a=$(systemctl status mysqld.service | grep "active (running)" | wc -l)

if [ $a -gt 0 ]
then
	echo "启动完成，状态正常"
	#配置MySQL
	echo "配置MySQL"

	str=$(grep "password is generated for root@localhost:" /var/log/mysqld.log)
	localPWD=${str##*"root@localhost: "}
	echo "数据库默认密码:"$localPWD
	export MYSQL_PWD=$localPWD
	echo "重置数据库密码为:"$mysqlPWD
	mysql --connect-expired-password -uroot  -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysqlPWD'"

	echo "刷新权限"
	export MYSQL_PWD=$mysqlPWD
	mysql --connect-expired-password -uroot  -e "flush privileges"

	echo "配置远程登录"
	mysql --connect-expired-password -uroot  -e "grant all privileges on *.* to 'root'@'%' identified by '$mysqlPWD' with grant option"

	echo "配置数据库编码"
	echo "[client]" > /etc/my.cnf
	echo "default-character-set=utf8" >> /etc/my.cnf
	echo "" >> /etc/my.cnf
	echo "[mysqld]" >> /etc/my.cnf
	echo "datadir=/var/lib/mysql" >> /etc/my.cnf
	echo "socket=/var/lib/mysql/mysql.sock" >> /etc/my.cnf
	echo "character-set-server=utf8" >> /etc/my.cnf
	echo "collation-server=utf8_general_ci" >> /etc/my.cnf
	cat /etc/my.cnf

	#重启MySQL查看配置结果
	systemctl restart mysqld
	systemctl status mysqld.service

	mysql --connect-expired-password -uroot  -e "status"

	echo -e "安装完成,数据库密码: \033[31m"$mysqlPWD"\033[0m"
else
	echo "状态异常，安装失败"
fi
#rm -f mysql57-community-release-el7-10.noarch.rpm
echo "exit"