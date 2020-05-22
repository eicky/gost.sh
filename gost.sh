 #!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

sh_ver=1.0.1
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
  fi
	bit=$(uname -m)
        if test "$bit" != "x86_64"; then
           echo "请输入你的芯片架构，/386/armv5/armv6/armv7/armv8"
           read bit
        else bit="amd64"
        fi
}

Installation_dependency(){
	gzip_ver=$(gzip -V)
	if [[ -z ${gzip_ver} ]]; then
		if [[ ${release} == "centos" ]]; then
			yum update
			yum install -y gzip
		else
			apt-get update
			apt-get install -y gzip
		fi
	fi
}

check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前非ROOT账号(或没有ROOT权限)，无法继续操作，请更换ROOT账号或使用 ${Green_background_prefix}sudo su${Font_color_suffix} 命令获取临时ROOT权限（执行后可能会提示输入当前账号的密码）。" && exit 1
}

check_new_ver(){
ct_new_ver=$(wget --no-check-certificate -qO- -t2 -T3 https://gost.eicky.workers.dev | grep "tag_name"| head -n 1| awk -F ":" '{print $2}'| sed 's/\"//g;s/,//g;s/ //g;s/v//g')
  if [[ -z ${ct_new_ver} ]]; then
		echo -e "${Error} gost 最新版本获取失败，请手动获取最新版本号[ https://github.com/ginuerzh/gost/releases ]"
		read -e -p "请输入版本号 [ 格式 x.x.xx , 如 2.11.0 ] :" ct_new_ver
		[[ -z "${ct_new_ver}" ]] && echo "取消..." && exit 1
	else
		echo -e "${Info} gost 目前最新版本为 ${ct_new_ver}"
	fi
}
check_file(){
            if test ! -d "/usr/lib/systemd/system/";then
             `mkdir /usr/lib/systemd/system`
             `chmod -R 777 /usr/lib/systemd/system`
            fi
}
check_nor_file(){
           `rm -rf "$(pwd)"/gost`
           `rm -rf "$(pwd)"/gost.service`
           `rm -rf "$(pwd)"/config.json`
           `rm -rf /etc/gost`
           `rm -rf /usr/lib/systemd/system/gost.service`
           `rm -rf /usr/bin/gost`
}

Install_ct(){
            check_root
            check_nor_file
            Installation_dependency
            check_file
            check_sys
            check_new_ver
            `wget --no-check-certificate https://gh.334433.xyz/https://github.com/ginuerzh/gost/releases/download/v"$ct_new_ver"/gost-linux-"$bit"-"$ct_new_ver".gz`
            `gunzip gost-linux-"$bit"-"$ct_new_ver".gz`
            `mv gost-linux-"$bit"-"$ct_new_ver" gost`
            `mv gost /usr/bin/gost`
            `chmod -R 777 /usr/bin/gost`
            `wget --no-check-certificate https://cdn.jsdelivr.net/gh/eicky/gost.sh/gost.service && chmod -R 777 gost.service && mv gost.service /usr/lib/systemd/system`
            `mkdir /etc/gost && wget --no-check-certificate https://cdn.jsdelivr.net/gh/eicky/gost.sh/config.json && mv config.json /etc/gost && chmod -R 777 /etc/gost`
            `systemctl enable gost && systemctl restart gost`
            echo "------------------------------"
            if test -a /usr/bin/gost -a /usr/lib/systemctl/gost.service -a /etc/gost/config.json;then
             echo -e "${Green_font_prefix} gost似乎安装成功 ${Font_color_suffix}"
             `rm -rf "$(pwd)"/gost`
             `rm -rf "$(pwd)"/gost.service`
             `rm -rf "$(pwd)"/config.json`
            else
             echo -e "${Red_font_prefix} gost没有安装成功，可以提issues[https://github.com/eicky/gost.sh]反馈 ${Font_color_suffix}"
             `rm -rf "$(pwd)"/gost`
             `rm -rf "$(pwd)"/gost.service`
             `rm -rf "$(pwd)"/config.json`
             `rm -rf "$(pwd)"/gost.sh`
            fi
}

Uninstall_ct(){
             `rm -rf /usr/bin/gost`
             `rm -rf /usr/lib/systemd/system/gost.service`
             `rm -rf /etc/gost`
             `rm -rf "$(pwd)"/gost.sh`
             echo -e "${Red_font_prefix} gost已经成功删除 ${Font_color_suffix}"
}

Start_ct(){
          `systemctl start gost`
          echo -e "${Green_font_prefix} 已启动 ${Font_color_suffix}"
}

Stop_ct(){
          `systemctl stop gost`
          echo -e "${Green_font_prefix} 已停止 ${Font_color_suffix}"  
}

Restart_ct(){
          `systemctl restart gost`
          echo -e "${Green_font_prefix} 已重启 ${Font_color_suffix}" 
}

Status_ct(){
          echo -e "${Green_font_prefix} 请检查 ${Font_color_suffix}" 
          echo -e "`systemctl status gost`"
}

Config_ct(){
          echo -e "${Green_font_prefix} 配置文件路径: /etc/gost/config.json ${Font_color_suffix}" 
          echo -e "`cat /etc/gost/config.json`"
}

echo "the last version has been launched in my blog" 
echo && echo -e "       Gost一键安装脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- Eicky | https://eicky.com ----
  
 ${Green_font_prefix}1.${Font_color_suffix} 安装 gost
 ${Green_font_prefix}2.${Font_color_suffix} 卸载 gost
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 启动 gost
 ${Green_font_prefix}4.${Font_color_suffix} 停止 gost
 ${Green_font_prefix}5.${Font_color_suffix} 重启 gost
 ${Green_font_prefix}6.${Font_color_suffix} 状态 gost 
 ${Green_font_prefix}7.${Font_color_suffix} 配置 gost 
————————————" && echo
read -e -p " 请输入数字 [1-7]:" num
case "$num" in
  1)
  Install_ct
  ;;
  2)
  Uninstall_ct
  ;;
  3)
  Start_ct
  ;;
  4)
  Stop_ct
  ;;
  5)
  Restart_ct
  ;;
  6)
  Status_ct
  ;;
  7)
  Config_ct
  ;;
  *)
  echo "请输入正确数字 [1-7]"
  ;;
esac
