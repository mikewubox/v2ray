
## V2ray4.27一鍵mKCP安裝純净極速版+BBR+iptables安全代码
加了强化VPS安全的iptable规则代码，反扫描，拉黑IP,10个月，反攻击；

bash <(curl -Ls https://raw.githubusercontent.com/mikewubox/v2ray/master/mkcp/install.sh)

查看配置 cat ./v2ray_info.txt

匹配 v2rayN win64 客户端 https://github.com/mikewubox/v2ray/tree/master/v2rayn321
           作者网址 https://github.com/2dust/v2rayN/releases
## Debian10常用软件包
   root用户下安装,如果用iptables代码，请关闭防火墙ufw

#apt-get -y update && apt-get -y install unzip zip wget curl mc nano sudo socat ntp ntpdate gcc git

## CentOS8常用软件包
   root用户下安装，如果用iptables代码，请关闭防火墙firewalld

#yum -y update && yum -y install unzip zip wget nano sudo curl  redhat-lsb epel-release socat gcc git


# 收集一键脚本，所有权利归原作者所有。
除了官网一键代码，各路大神的大多数原版一键脚本已删贴走人隐居甚至失效。

## v2ray4.27独立版官方克隆脚本安装
#bash <(curl -Ls https://raw.githubusercontent.com/mikewubox/tvonekey/master/go.sh)



#  基于Nginx 的 vmess+ws+tls 一键安装脚本
#bash <(curl -L -s https://raw.githubusercontent.com/mikewubox/V2Ray_ws-tls_bash_onekey/master/install.sh) | tee v2ray_ins.log
