# V2Ray mKCP一键急速純净安裝脚本 （基於wulabing大神一鍵代碼修改）

> 建议遇到问题的用户重置系统后重新安装

### 查看客户端配置
放在执行脚本所在目录下的 v2ray_info.txt
### V2ray 简介
* V2Ray是一个优秀的开源网络代理工具，可以帮助你畅爽体验互联网，目前已经全平台支持Windows、Mac、Android、IOS、Linux等操作系统的使用。
* 本脚本为一键完全配置脚本，在所有流程正常运行完毕后，直接按照输出结果设置客户端即可使用
* 已安装的用户，当出现无法连接的情况时，请用户根据该文档更新 V2ray core 
* 请注意：我们依然强烈建议你全方面的了解整个程序的工作流程及原理


## 注意事项
* 推荐在纯净环境下使用本脚本，如果你是新手，请不要使用Centos系统。
* 在尝试本脚本确实可用之前，请不要将本程序应用于生产环境中。
* V2Ray 的部分功能依赖于系统时间，请确保您使用V2RAY程序的系统 UTC 时间误差在三分钟之内，时区无关。
## 准备工作
* [V2ray官方说明](https://www.v2ray.com/)，了解 TLS WebSocket 及 V2ray 相关信息
* 安装好 curl
## Debian9，10常用软件包，root用户下安装

#apt-get -y update && apt-get -y install unzip zip wget curl  nano sudo ufw socat ntp ntpdate gcc git

## CentOS7.6 8常用软件包，root用户下安装

#yum -y update && yum -y install unzip zip wget nano sudo curl firewalld redhat-lsb epel-release socat gcc git



## 查看客户端配置信息

cat ./v2ray_info.txt

### 启动方式

启动 V2ray：`systemctl start v2ray`

停止 V2ray：`systemctl stop v2ray`

狀態 V2ray：systemctl status v2ray


V2ray 服务端配置：`/etc/v2ray/config.json`

V2ray 客户端配置: cat ./v2ray_info.txt



.


