## 收集一键脚本，所有权利归原作者，本人不是程序员，也不懂代码。
## v2ray官网一键代码失效，v2fly算是个全新的工具，安装、配置、兼容都有变化，不习惯。
## 基于安全、简单、有效，个人娱乐原则收集。
## v4.25对老版本客户端兼容更好 v4.27的服务器只能兼容v4.27的客户端

## Debian10常用软件包
   root用户下安装,如果用iptables代码，请关闭防火墙ufw

#apt-get -y update && apt-get -y install unzip zip wget curl mc nano sudo socat ntp ntpdate gcc git

## CentOS8常用软件包
   root用户下安装，如果用iptables代码，请关闭防火墙firewalld

#yum -y update && yum -y install unzip zip wget nano sudo curl  redhat-lsb epel-release socat gcc git

## V2ray4.27一鍵完事，mKCP安裝純净極速版+BBR+iptables安全代码
加了强化VPS安全的iptable规则代码，反扫描，拉黑IP,10个月，反攻击；

#bash <(curl -Ls https://raw.githubusercontent.com/mikewubox/v2ray/master/mkcp/install.sh)

查看配置 cat ./v2ray_info.txt

v2ray4.27版客户端版本，能兼容老版本和4.27版服务器

对应的v2rayN3.21版 win64 客户端 https://github.com/mikewubox/v2ray/tree/master/v2rayn321
           
v2rayN  作者网址  https://github.com/2dust/v2rayN/releases

安卓版对应的是V2rayNG1.3,作者网址--同上

## v2ray4.25或4.27独立版单独安装，无配置
#wget  https://raw.githubusercontent.com/mikewubox/v2ray/master/go.sh

#wget  https://github.com/mikewubox/v2ray/raw/master/v2ray425/v2ray-linux-64.zip   ##安装4.25版##

或

#wget  https://github.com/mikewubox/v2ray/raw/master/v2ray427/v2ray-linux-64.zip   ##安装4.27版##
    
#chmod 777 go.sh

#chmod 777 v2ray-linux-64.zip

#./go.sh --local v2ray-linux-64.zip

#  基于Nginx 的 vmess+ws+tls 一键安装脚本
#bash <(curl -L -s https://raw.githubusercontent.com/mikewubox/V2Ray_ws-tls_bash_onekey/master/install.sh) | tee v2ray_ins.log
