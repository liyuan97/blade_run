#!/bin/bash
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
fi
green $release
red $systemPackage

environmentPath="~/.bashrc"


re2c_install(){
	if type re2c >/dev/null 2>&1; then
    	red '1. re2c 已安装';
		sleep 0.5s
    	return
	fi
	file_name=re2c-0.12.1.tar.gz
	if test -s $file_name; then
		echo "re2c-0.12.1.tar.gz exist"
	else
		wget https://src.fedoraproject.org/lookaside/extras/re2c/re2c-0.12.1.tar.gz/6ac50ad6412e90b38d499a28df42af68/re2c-0.12.1.tar.gz
	fi
 	tar -xvzf re2c-0.12.1.tar.gz
 	cd re2c-0.12.1 && ./configure
 	make && make install
 	cd ..
 	green "1.re2c 安装成功，请继续"
}


ninja_install(){

	if type ninja >/dev/null 2>&1; then
    	red '2. ninja 已安装';
    	sleep 0.5s
    	return
	fi

	if test -s ninja; then 
		git clone git://github.com/ninja-build/ninja.git 
	else
		cd ninja
	fi
	./configure.py --bootstrap
	cp ninja /usr/bin/
	cd ..
	green "2.ninja 安装成功，请继续"
}


blade_install(){
	if type blade >/dev/null 2>&1; then
    	red '3. blade 已安装';
    	sleep 0.5s
    	return
	fi

	file_name=blade.tar
	if test -s $file_name; then
		echo "blade.tar exist"
	else
		wget https://cycleli-1256620856.cos.ap-nanjing.myqcloud.com/blade.tar
	fi
	tar xvf blade.tar
	cd blade-build
	echo "export PATH=\"$PATH:$pwd\""   >> ~/.bashrc
	cd ..
	green "3.blade 安装成功，请继续"
}

ccache_install(){
	if type ccache >/dev/null 2>&1; then
    	red '4. ccache 已安装';
    	sleep 0.5s
    	return
	fi

	wget https://www.samba.org//ftp/ccache/ccache-3.6.tar.xz
	tar -xvf ccache-3.6.tar.xz
	cd ccache-3.6
	./configure -prefix=/var/ccache
	make -j8
	make install

	# ln -s /var/ccache/bin/ccache /usr/bin/ccache

	echo "export CCACHE_DIR=/data/.ccache" >> ~/.bashrc  #写入环境配置文件中
	echo "export USE_CCACHE=1" >> ~/.bashrc
	source ~/.bashrc 
	green "4.ccache 安装成功，请继续"
}

change_dir(){
	green "当前目录"
	ls -al
	green "请输入目标目录"
	read dirpath
	cd $dirpath
}

check_my_env(){
	if type re2c >/dev/null 2>&1; then
    	red 're2c 已安装';
	fi
	if type ninja >/dev/null 2>&1; then
    	red 'ninja 已安装';
	fi
	if type blade >/dev/null 2>&1; then
    	red 'blade 已安装';
	fi
	if type ccache >/dev/null 2>&1; then
    	red 'ccache 已安装';
	fi
	if [[ $? -eq 1 ]]; then 
		green "环境正常，re2c ninja blade ccache已安装"
	fi
	sucess
}

sucess(){
	blue "blade 详细介绍: https://iwiki.woa.com/pages/viewpage.action?pageId=487144353"
	green "成功安装四个模块，按回车退出。"
	read test
}

# echo "export JAVA_HOME=$environment" >> ~/.bashrc  #将需要配置的JAVA_HOME写入环境配置文件中
# echo "export PATH=$environment/bin:\$PATH" >> ~/.bashrc
# source ~/.bashrc

# change_panel(){
# if test -s /etc/systemd/system/trojan-web.service; then
# 	green " "
# 	green " "
# 	green "================================="
# 	 blue "  检测到Trojan面板服务，开始配置"
# 	green "================================="
# 	sleep 2s
# 	# $systemPackage update -y
# 	# $systemPackage -y install nginx unzip curl wget
# 	# systemctl enable nginx
# 	# systemctl stop nginx
# if test -s /etc/nginx/nginx.conf; then
# 	# rm -rf /etc/nginx/nginx.conf
#   # wget -P /etc/nginx https://raw.githubusercontent.com/V2RaySSR/Trojan_panel_web/master/nginx.conf
# 	green "================================="
# 	blue "     请输入Trojan绑定的域名"
# 	green "================================="
# 	read your_domain
#   # sed -i "s/localhost/$your_domain/;" /etc/nginx/nginx.conf
# 	green " "
# 	green "================================="
# 	 blue "    开始下载伪装站点源码并部署"
# 	green "================================="
# 	sleep 2s
# 	# rm -rf /usr/share/nginx/html/*
# 	# cd /usr/share/nginx/html/
# 	# wget https://github.com/V2RaySSR/Trojan/raw/master/web.zip
# 	# unzip web.zip
# 	green " "
# 	green "================================="
# 	blue "       开始配置trojan-web"
# 	green "================================="
# 	sleep 2s
#   # sed -i '/ExecStart/s/trojan web -p 81/trojan web/g' /etc/systemd/system/trojan-web.service
#   # sed -i '/ExecStart/s/trojan web/trojan web -p 81/g' /etc/systemd/system/trojan-web.service
#   # systemctl daemon-reload
#   # systemctl restart trojan-web
#   # systemctl restart nginx
#   green " "
#   green " "
#   green " "
# 	green "=================================================================="
# 	green " "
# 	 blue "  WIN / MAC 通用客户端下载、本脚本更多介绍内容 "
# 	 blue "  https://www.v2rayssr.com/trojanpanel.html "
# 	green " "
# 	 blue "  脚本交流电报群：https://goii.cc/tg"
# 	green " "
# 	 blue "  伪装站点目录 /usr/share/nginx/html "
# 	 blue "  面板管理地址 http://$your_domain:81 "
# 	green "=================================================================="
# else
# 	green "==============================="
# 	  red "     Nginx未正确安装 请重试"
# 	green "==============================="
# 	sleep 2s
# 	exit 1
# fi
# else
# 	green "==============================="
# 	  red "    未检测到Trojan面板服务"
# 	green "==============================="
# 	sleep 2s
# 	exit 1
# fi
# }

# bbr_boost_sh(){
#     $systemPackage install -y wget
#     # wget -N --no-check-certificate -q -O tcp.sh "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && bash tcp.sh
# }

# trojan_install(){
#     $systemPackage install -y curl
# 		source <(curl -sL https://git.io/trojan-install)
# }

start_menu(){
systemPackage install -y wget
  clear	
    green "=========================================================="
   	blue " 简介：一键安装 re2c ninja blade ccache 编译环境，提高开发效率100%"
	green "=========================================================="
   	blue " 版本：1.0.0 cycleli"
	green "=========================================================="
    blue " 本脚本支持：Debian9+ / Ubuntu16.04+ / Centos7+"
	green "=========================================================="
	red  " 运行本脚本之前请确认可以链接访问外网，建议用root权限安装。"
	green "=========================================================="
	blue "blade 详细介绍: https://iwiki.woa.com/x/oTsJHQ"
	green "=========================================================="
	blue "请按照顺序依次运行，如果有报错，参考iwiki排查问题。"
	green "=========================================================="
	blue "当前目录: "
	red "$(pwd) "
	blue "如果修改，请按5"
	green "=========================================================="
	blue " 000. 检查当前环境"
	blue " 1. 安装 re2c"
   	blue " 2. 安装 ninja"
   	blue " 3. 安装 blade"
   	blue " 4. 安装 ccache"
   	blue " 5. 手动修改下载目录"
	blue " 9. 一键默认全部安装re2c ninja blade ccache"
   	blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    	000)
		check_my_env
		;;
    	1)
		re2c_install
		sleep 1.5s
		start_menu
		;;
		2)
		ninja_install
		sleep 1.5s
		start_menu
		;;
		3)
		blade_install
		sleep 1.5s
		start_menu
		;;
		4)
		ccache_install
		sleep 1.5s
		start_menu
		;;
		5)
		change_dir
		start_menu
		;;
		9)
		re2c_install
		ninja_install
		blade_install
		ccache_install
		check_my_env
		;;
		0)
		exit 0
		;;
		*)
	clear
	echo "请输入正确数字"
	sleep 2s
	start_menu
	;;
    esac
}

start_menu