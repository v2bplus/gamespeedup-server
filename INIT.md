
## 初始化环境(CentOS)

1. 安装docker
```bash
## 国内机器
   curl -sSL https://get.daocloud.io/docker | sh
## 海外机器
   curl -fsSL https://get.docker.com | sh
```
2. 安装docker-compose
```bash

## github
curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```
3. 设置repo
   
```bash
## centos
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

## debian

```
4. 开机启动
```
systemctl disable nginx
systemctl enable docker
```

5. 查看docker版本
```
docker version
```

6. 设置国内镜像  
   
   `/etc/docker/daemon.json` (没有就新建)
```json
{
  "log-driver": "json-file",
  "log-opts": {
     "max-size": "20m",
     "max-file": "3"
  },
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
// 海外服务器不需要设置国内镜像

```

7. 检查
```
systemctl restart docker 
docker info 
```

8. 关闭防火墙
```bash

systemctl disable firewalld.service
systemctl stop firewalld.service

systemctl daemon-reload
```
9. 优化宿主机网络
链接参考 ([https://zhuanlan.zhihu.com/p/453788129](https://zhuanlan.zhihu.com/p/453788129))
```bash
# wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
chmod +x ./shell/bbr.sh
./shell/bbr.sh

10. 生成ssh私钥 
```bash
ssh-keygen -t ed25519 -C "julian@gamespeedup.cn"

cat /root/.ssh/id_ed25519.pub
```
11. 设置时间

本地时区设置
```bash
## centos
timedatectl set-timezone Asia/Shanghai
## debian
timedatectl set-timezone Asia/Shanghai

```
crontab 设置

```bash
0 2 * * * (/usr/sbin/ntpdate ntp1.aliyun.com && /sbin/hwclock -w) > /dev/null 2>&1
```

## 绑定域名

1. 购买域名
   wwww.xxxxx.com

2. DNS设置域名
   www.xxxxx.com 127.0.0.1(服务器ip)

## 初始化证书步骤

### 必须安装nginx(acme需要验证)
```bash
## centos
rpm -Uvh  http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install nginx
## debian 11
export LANG=zh_CN.UTF-8
apt install git nginx vim
```
### 安装 acme.sh
```bash
## centos
yum install socat git
git clone https://github.com/Neilpang/acme.sh.git /data/acme.sh
cd /data/acme.sh
./acme.sh --install
source ~/.bashrc

## debian 11
apt install socat
git clone https://github.com/acmesh-official/acme.sh.git /data/acme.sh
cd /data/acme.sh
./acme.sh --install -m my@gamespeedup.cn

source ~/.bashrc

# 修改证书生成方式为letsencrypt
# acme.sh --register-account -m $RANDOM@gamespeedup.cn
# 这种方式容易失败,所以切换服务为letsencrypt
acme.sh --set-default-ca --server letsencrypt
```

### 请求生成证书 (acme方式)
```bash
# 第一次获取证书
## centos
systemctl start nginx
vi /etc/nginx/conf.d/default.conf
修改成部署的域名
acme.sh --issue -d game.trojanshare.cc -w nginx:/etc/nginx/conf.d/default.conf --insecure

## debian 11
echo "Creating /etc/nginx/conf.d/default.conf"
(
cat <<'EOF'
server {
     listen       80;
     server_name  game.trojanshare.cc;
     location / {
         root   html;
         index  index.html index.htm;
     }
     error_page   500 502 503 504  /50x.html;
     location = /50x.html {
         root   html;
     }
 }
EOF
) | tee /etc/nginx/conf.d/default.conf

acme.sh --issue -d game.trojanshare.cc -w nginx:/etc/nginx/conf.d/default.conf --insecure
acme.sh --issue -d game.trojanshare.cc -w nginx:/usr/local/nginx/conf/nginx.conf--force --log

这样生成的了自己的域名证书

```
### 安装证书完整步骤 
 等待系统部署完成后


### 异常
```bash
# 安装docker之后系统可能出现  kernel:unregister_netdevice: waiting for lo to become free. Usage count = 1 错误

systemctl stop rsyslog
vi /etc/rsyslog.conf
#*.emerg :omusrmsg:*
# 注释掉 *.emerg 重启服务就可以了
systemctl start rsyslog

```
