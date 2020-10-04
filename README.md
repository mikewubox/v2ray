### 网上收集的一键脚本，所有权利归原作者，本人不是程序员，也不懂代码。
### v2ray官网一键代码失效，v2fly算是个全新的工具，安装、配置、兼容都有变化，个人自用老版本足矣。
##### 基于安全、简单、有效原则收集。本地安装参考源 https://www.v2ray.com/chapter_00/install.html#gosh
### v4.25对老版本客户端兼容更好 v4.27的服务器只能兼容v4.27的客户端
### 安全第一，謹防VPS大盜，劫持你的VPS，盗窃流量。
#### 多用戶多端口配置生成 https://intmainreturn0.com/v2ray-config-gen/
#### UUID 生成 https://www.uuidgenerator.net/
#### SSL Security Test https://www.immuniweb.com/ssl/
#### SSL Configuration Generator https://ssl-config.mozilla.org/
#### 強隨機密碼生成（至少16位）https://passwordsgenerator.net/
#### 瀏覽器安全檢測 https://www.cloudflare.com/ssl/encrypted-sni/
#### 免费在线扫描器 简易测试VPS安全防护情况 https://geekflare.com/port-scanner-server/
#### 扫描nmap指令参考集（进一步测试自己VPS安全防卫效果） https://securitytrails.com/blog/top-15-nmap-commands-to-scan-remote-hosts  
####      　      　      　       　              https://www.stationx.net/nmap-cheat-sheet/
####          　      　                          https://phoenixnap.com/kb/nmap-command-linux-examples
 　 
## Debian10常用软件包
   root用户下安装,如果用iptables代码，请关闭防火墙ufw

#apt-get -y update && apt-get -y install unzip zip wget curl mc nano sudo socat ntp ntpdate gcc git

## CentOS8常用软件包
   root用户下安装，如果用iptables代码，请关闭防火墙firewalld

#yum -y update && yum -y install unzip zip wget nano sudo curl  redhat-lsb epel-release socat gcc git

## V2ray4.27一鍵完事，mKCP安裝純净極速版+BBR+iptables安全代码
### 加了强化VPS安全的iptable规则代码，反扫描，拉黑IP,10个月，反攻击；
### Generates random server port &UUID&alterID

#bash <(curl -Ls https://raw.githubusercontent.com/mikewubox/v2ray/master/mkcp/install.sh)

查看配置 cat ./v2ray_info.txt

v2ray4.27版客户端版本，能兼容老版本和4.27版服务器

对应的v2rayN3.21版 win64 客户端 https://github.com/mikewubox/v2ray/tree/master/v2rayn321
           
v2rayN  作者网址  https://github.com/2dust/v2rayN/releases

安卓版对应的是V2rayNG1.3,作者网址--同上

###  v4.27版，基于Nginx 的 vmess+ws+tls+CDN 一键安装脚本+BBR+iptables安全代码，仅支持TLS1.2,TLS1.3 
### 简单快捷一键完事，只需输入域名。端口默认443，Generates random UUID&alterID
### 安装之前注册一个域名，并在cludflare解析好域名，新人建议用干净的debian10 VPS
#### 伪装网站看不出啥作用。https://github.com/mikewubox/mikewubox.github.io
### 重点--安装完毕后设置cloudflare白名单防火墙，杜绝非法扫描及访问。


#bash <(curl -L -s https://raw.githubusercontent.com/mikewubox/v2ray/master/install.sh) | tee v2ray_ins.log

查看配置 cat ./v2ray_info.txt

## v2ray4.25或4.27独立版单独安装，无配置（V2fly大神们认为VMESS已不安全，大家用不用自定）
#wget  https://raw.githubusercontent.com/mikewubox/v2ray/master/go.sh

#wget  https://github.com/mikewubox/v2ray/raw/master/v2ray425/v2ray-linux-64.zip   ##安装4.25版##

或

#wget  https://github.com/mikewubox/v2ray/raw/master/v2ray427/v2ray-linux-64.zip   ##安装4.27版##
    
#chmod 777 go.sh

#chmod 777 v2ray-linux-64.zip

#./go.sh --local v2ray-linux-64.zip
