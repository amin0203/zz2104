#!/bin/bash
clear
echo "=========================================="
systemctl status nginx &> /dev/null
if [ $? -eq 0 ];then
	echo "nginx已经启动"
else
	echo "nginx未启动" 
fi
echo "=========================================="
sleep 0.5
systemctl status mysql &> /dev/null
if [ $? -eq 0 ];then
	echo "mysql已经启动"
else
	echo "mysql未启动"
fi
echo "=========================================="
sleep 0.5 && echo "当前系统时间为：" && date
echo "=========================================="
sleep 0.5 && echo "当前主机名为：" && cat /etc/hostname
echo "=========================================="
sleep 0.5 && echo "当前用户为：" && whoami
echo "=========================================="
sleep 0.5 && echo "当前ip为："
ip a|grep 'ens33'|awk 'NR==2 {print $2}'|awk -F '/' '{print $1}'
echo "=========================================="
sleep 0.5 && echo "当前磁盘使用情况：" &&lsblk
echo "=========================================="
sleep 0.5 && echo "当前系统负载情况：" && uptime
echo "==========================================" && sleep 0.5 && echo




while :
do
cat<<EOF
=================================================
|	1、配置WEB服务				|
|	2、配置MYSQL服务			|
|	3、配置Network服务			|	
|	4、更改密码				|	
|	5、配置YUM				|
|	6、关闭并开机关闭防火墙、SeLinux	|
|	7、清空当前内存缓存			|
|	8、退出					|
=================================================
EOF
read -p "请输入您要进行的服务的数字：" fuwu
case $fuwu in
1)
	while :
	do
	cat<<-EOF
	=========================
	|	1：启动WEB服务	|
	|	2：停止WEB服务	|
	|	3：重启WEB服务	|
	|	4：返回上一级	|
	=========================
	EOF
	read -p "请输入您要进行的服务的数字：" fuwu2
	case $fuwu2 in
	1)
	echo "正在为您验证epel源,请稍候..."
	yum install -y epel-release &> /dev/null
	echo "正在为您验证安装nginx，请稍候..."
	yum install -y nginx &> /dev/null
	echo "正在为您启动nginx..."
	systemctl start nginx &> /dev/null
	systemctl status nginx &> /dev/null 
	if [ $? -eq 0 ];then
		echo "nginx已正常启动！"
		continue
	else
		echo "nginx不能正常启动！"
		break
	fi
	;;
	2)
	echo "正在为您停止nginx，请稍候..."
	systemctl stop nginx &> /dev/null
	if [ $? -eq 0 ];then
		echo "nginx已经停止！"
	else
		echo "nginx未能正常关闭！"
	fi
	;;
	3)
	echo "正在为您重启WEB服务nginx..."
	systemctl restart nginx &> /dev/null
	if [ $? -eq 0 ];then
		echo "nginx已经重启成功！"
	else
		echo "nginx未能正常重启！"
	fi
	;;
	4)
	break
	;;
	*)
	echo "您的输入有误，请重新输入！"
	continue
	;;
	esac
	done
continue
;;
2)
	while :
	do
	cat<<-EOF
	=========================
	|	1：启动MYSQL	|
	|	2：停止MYSQL	|
	|	3：重启MYSQL	|
	|	4：返回上一级	|
	=========================
	EOF
	read -p "请输入您要进行的服务的数字：" fuwu3
	case $fuwu3 in
	1)
		echo "正在验证安装mysql..."
		yum -y install mysql &> /dev/null
		if [ $? -eq 0 ];then
		        echo "开始启动MySQL..."
               		systemctl start mysql
                		if [ $? -eq 0 ]
                		then
                		        echo "启动MySQL成功"
                		else
	        		        echo "MySQL启动失败"
                		fi
		else
		        echo "请检查yun源"
		fi
	continue
	;;
	2)
		systemctl stop mysql
		if [ $? -eq 0 ]
		then
		        echo "停止MySQL成功"
		else
		        echo "停止Mysql失败。。。"
		fi
	continue
	;;
	3)
		systemctl restart  mysql 
		if [ $? -eq 0 ]
		then
		        echo "重启MySQL成功"
		else
		        echo "重启失败。。。"
		fi
	continue
	;;
	4)
	break
	;;
	*)
	echo "您的输入有误，请重新输入！"
	continue
	;;
	esac
	done
continue
;;
3)

continue
;;
4)
	echo "正在为您更改root密码..."
	echo "您当前的登录账户为："
	whoami
	if [ $UID -eq 0 ];then
		read -p "请输入您想要设置的密码：" passwd
		echo $passwd |passwd --stdin root
	else
		echo "您不是root用户！"
	fi
continue
;;
5)
	echo "正在检查yum源..."
        yum -y install vim  &> /dev/null
        if [ "$?" -eq "0" ];then
                echo "yum源可以正常使用"
                continue
        else
        read -p "yum源有问题，是否要更换yum源（Y/N）" huan
                if [ $huan == Y ];then
                        echo "正在为您准备yum源"
                        echo "1.http://mirrors.aliyun.com/repo/Centos-7.repo"
                        echo "2.http: //mirrors.163.com/.help/CentOS7-Base-163.repo"
                        read -p "请选择您要更换的yum源" cho
                                if [ $cho == 1 ];then
                                        curl http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/
                                        yum clean all && yum repolist

                                elif [$cho == 2 ];then
                                        curl http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/
                                        yum clean all && yum repolist
                	        else
                        	exit
                        	fi
		else
        	exit
	        fi
	fi
continue
;;
6)
	systemctl stop firewalld
	systemctl disable firewalld
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	echo "已关闭并开机关闭防火墙及selinux！"
continue
;;
7)
	echo 3>/proc/sys/vm/drop_caches
	echo "已经为您清理缓存！"
continue
;;
8)
	echo "再见！！！"
exit
;;
*)
echo "您的输入有误，请重新输入！"
continue
;;
esac
done




