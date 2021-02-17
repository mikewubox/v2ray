#!/bin/bash

#====================================================
#	System Request:Debian 9+/Ubuntu 18.04+/Centos 7+
#	Author:	wulabing
#	Dscription: V2ray ws+tls onekey 
#	Version: 5.1
#	email:wulabing@admin.com
#	Official document: www.v2ray.com
#====================================================

#fonts color
Green="\033[32m" 
Red="\033[31m" 
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

v2ray_conf_dir="/etc/v2ray"

v2ray_conf="${v2ray_conf_dir}/config.json"



source /etc/os-release

#从VERSION中提取发行版系统的英文名称，为了在debian/ubuntu下添加相对应的Nginx apt源
VERSION=`echo ${VERSION} | awk -F "[()]" '{print $2}'`

check_system(){
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]];then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
    elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]];then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        INS="apt"
        $INS update
        ## 添加 Nginx apt源
    elif [[ "${ID}" == "ubuntu" && `echo "${VERSION_ID}" | cut -d '.' -f1` -ge 16 ]];then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
        INS="apt"
        $INS update
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi

    systemctl stop firewalld && systemctl disable firewalld
    echo -e "${OK} ${GreenBG} firewalld 已关闭 ${Font}"
}

is_root(){
    if [ `id -u` == 0 ]
        then echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}" 
        exit 1
    fi
}
judge(){
    if [[ $? -eq 0 ]];then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}


dependency_install(){
    ${INS} install wget git lsof -y

    if [[ "${ID}" == "centos" ]];then
       ${INS} -y install crontabs
    else
       ${INS} -y install cron
    fi
    judge "安装 crontab"

    if [[ "${ID}" == "centos" ]];then
       touch /var/spool/cron/root && chmod 600 /var/spool/cron/root
       systemctl start crond && systemctl enable crond
    else
       touch /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root
       systemctl start cron && systemctl enable cron

    fi
    judge "crontab 自启动配置 "



    ${INS} -y install bc
    judge "安装 bc"

   

    
    

}
basic_optimization(){
    # BBR	
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
	judge "安装BBR"
	# 最大文件打开数
    sed -i '/^\*\ *soft\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    sed -i '/^\*\ *hard\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    echo '* soft nofile 65536' >> /etc/security/limits.conf
    echo '* hard nofile 65536' >> /etc/security/limits.conf

    # 关闭 Selinux
    if [[ "${ID}" == "centos" ]];then
        sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
        setenforce 0
    fi

}

get_ip() {
	ip=$(curl -s https://ipinfo.io/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ipify.org)
		
}
modify_port_UUID(){
    
	PORT=$(shuf -i10001-50001 -n1)
    UUID=$(cat /proc/sys/kernel/random/uuid)
	alterID=$(shuf -i1-100 -n1)
    sed -i "/\"port\"/c  \    \"port\":${PORT}," ${v2ray_conf}
    sed -i "/\"id\"/c \\\t  \"id\":\"${UUID}\"," ${v2ray_conf}
    sed -i "/\"alterId\"/c \\\t  \"alterId\":${alterID}" ${v2ray_conf}
    
}


v2ray_install(){
    if [[ -d /root/v2ray ]];then
        rm -rf /root/v2ray
    fi
    if [[ -d /etc/v2ray ]];then
        rm -rf /etc/v2ray
    fi
    mkdir -p /root/v2ray && cd /root/v2ray
   wget  https://raw.githubusercontent.com/mikewubox/v2ray/master/go.sh
   wget  https://github.com/mikewubox/v2ray/raw/master/v2ray427/v2ray-linux-64.zip
    ## wget go.sh v2ray4.27
    chmod 777 go.sh
    chmod 777 v2ray-linux-64.zip
    if [[ -f go.sh ]] ; then
        ./go.sh --local v2ray-linux-64.zip
        judge "安装 V2ray"
    else
        echo -e "${Error} ${RedBG} V2ray 安装文件下载失败，请检查下载地址是否可用 ${Font}"
        exit 4
    fi
    # 清除临时文件
    rm -rf /root/v2ray
}




v2ray_conf_add(){
    cd /etc/v2ray
    wget https://raw.githubusercontent.com/mikewubox/v2ray/master/mkcp/config.json -O config.json
modify_port_UUID
judge "V2ray 配置修改"
}


start_process_systemd(){
    

    systemctl restart v2ray
    judge "V2ray 启动"

    systemctl enable v2ray
    judge "设置 v2ray 开机自启"
}

#debian 系 9 10 适配
#rc_local_initialization(){
#    if [[ -f /etc/rc.local ]];then
#        chmod +x /etc/rc.local
#    else
#        touch /etc/rc.local && chmod +x /etc/rc.local
#        echo "#!/bin/bash" >> /etc/rc.local
#        systemctl start rc-local
#    fi
#
#    judge "rc.local 配置"
#}


vmess_qr_config(){
    cat >/etc/v2ray/vmess_qr.json <<-EOF
    {
        "v": "2",
        "ps": "v2KCP_${ip}",
        "add": "${ip}",
        "port": "${PORT}",
        "id": "${UUID}",
	"aid": "${alterID}",
        "net": "kcp",
        "type": "none",
        "host": "",
        "path": "",
        "tls": ""
    }
EOF

    vmess_link="vmess://$(cat /etc/v2ray/vmess_qr.json | base64 -w 0)"
    echo -e "${Red} URL导入链接:${vmess_link} ${Font}" >>./v2ray_info.txt
    
}

show_information(){
    clear
    cd ~

    echo -e "${OK} ${Green} V2ray+mKCP 安装成功" >./v2ray_info.txt
    echo -e "${Red} V2ray+mKCP配置信息 ${Font}" >>./v2ray_info.txt
    echo -e "${Red} 地址（address）:${Font} ${ip} " >>./v2ray_info.txt
    echo -e "${Red} 端口（port）：${Font} ${PORT} " >>./v2ray_info.txt
    echo -e "${Red} 用户id（UUID）：${Font} ${UUID}" >>./v2ray_info.txt
    echo -e "${Red} 额外id（alterId）：${Font} ${alterID}" >>./v2ray_info.txt
    echo -e "${Red} 加密方式（security）：${Font} auto " >>./v2ray_info.txt
    echo -e "${Red} 传输协议（network）：${Font} kcp " >>./v2ray_info.txt
    echo -e "${Red} 伪装类型（type）：${Font} none " >>./v2ray_info.txt
    echo -e "${Red} 路径（不要落下/）：${Font}  " >>./v2ray_info.txt
    echo -e "${Red} 底层传输安全：${Font} " >>./v2ray_info.txt
    vmess_qr_config
    cat ./v2ray_info.txt

}

firewall_iptables(){
    ### first flush all the iptables Rules
    iptables -F


    # INPUT iptables Rules
    # Accept loopback input
    iptables -A INPUT -i lo -p all -j ACCEPT

    # allow 3 way handshake
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    ### DROPspoofing packets
    iptables -A INPUT -s 10.0.0.0/8 -j DROP 
    iptables -A INPUT -s 169.254.0.0/16 -j DROP
    iptables -A INPUT -s 172.16.0.0/12 -j DROP
    iptables -A INPUT -s 127.0.0.0/8 -j DROP
    iptables -A INPUT -s 192.168.0.0/24 -j DROP

    iptables -A INPUT -s 224.0.0.0/4 -j DROP
    iptables -A INPUT -d 224.0.0.0/4 -j DROP
    iptables -A INPUT -s 240.0.0.0/5 -j DROP
    iptables -A INPUT -d 240.0.0.0/5 -j DROP
    iptables -A INPUT -s 0.0.0.0/8 -j DROP
    iptables -A INPUT -d 0.0.0.0/8 -j DROP
    iptables -A INPUT -d 239.255.255.0/24 -j DROP
    iptables -A INPUT -d 255.255.255.255 -j DROP

    #for SMURF attack protection
    iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
    iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
    #iptables -A INPUT -p icmp -m icmp -m limit --limit 1/second --limit-burst 2 -j ACCEPT

    # Droping all invalid packets
    iptables -A INPUT -m state --state INVALID -j DROP
    iptables -A FORWARD -m state --state INVALID -j DROP
    iptables -A OUTPUT -m state --state INVALID -j DROP

    # flooding of RST packets, smurf attack Rejection
    iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

    # Protecting portscans
    # Attacking IP will be locked for 24 hours X 30 days X10(3600 x 24 x 30 X 10 = 25920000 Seconds)
    iptables -A INPUT -m recent --name portscan --rcheck --seconds 25920000 -j DROP
    iptables -A FORWARD -m recent --name portscan --rcheck --seconds 25920000 -j DROP

    # Remove attacking IP after 10 months
    iptables -A INPUT -m recent --name portscan --remove
    iptables -A FORWARD -m recent --name portscan --remove

    # These rules add scanners to the portscan list, and log the attempt.
    iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
    iptables -A INPUT -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

    iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "portscan:"
    iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

    # Allow the following ports through from outside
    iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport $PORT -j ACCEPT

    # block ping means ICMP port is close (If you do not want ping replace ACCEPT with REJECT)
    iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
    iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

    # Lastly DROP All INPUT traffic
    iptables -A INPUT -j DROP
    apt-get install -y iptables-persistent
}

main(){
    is_root
    check_system
    
    dependency_install
    basic_optimization
    get_ip  
    v2ray_install
        
    v2ray_conf_add
   
    #将证书生成放在最后，尽量避免多次尝试脚本从而造成的多次证书申请
    firewall_iptables
    show_information
    start_process_systemd
   
}

main

