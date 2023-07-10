# GameSpeedUp

### 目录结构

```bash
├── INIT.md               // 初始化
├── README.md  
├── html
│   ├── game_admin_html   // 管理后台静态页面
│   ├── game_web_html     // 用户前台静态页面
│   └── tohttps           // 跳转https
├── proxy1
├── services              // docker 构建应用目录
├── shell
│   ├── bbr.sh
│   ├── check_resque.sh
│   └── crontab.sh
├── uptime                // uptime监控系统
│   ├── config
│   ├── docker-compose.yml
│   └── logs
└── web                   // web项目
    ├── config
    ├── docker-compose.yml
    ├── logs
    └── nginx
```

### 部署步骤

1. 拉取代码
```bash
## 本仓库代码
git clone git@github.com:v2bplus/gamespeedup-server.git /data/docker_compose

## 后台api代码
git clone 
```

2. 修改配置

```bash
## Todo
```

3. 启动web
   
```bash

cd /data/docker_compose/web
## 编译镜像
docker-compose build 
docker-compose up -d
docker-compose logs
```

4. 代理服务器启动 (可选)
```bash
# docker network create game --driver bridge
cd /data/docker_compose/proxy1
docker-compose build
docker-compose up -d
docker-compose logs
```

5. 启动uptime监控 (可选)

```bash
cd /data/docker_compose/uptime
docker-compose build
docker-compose up -d
docker-compose logs
```
### 上线初始化

##### 后台管理接口

```bash
docker exec -it PROXY_php82 sh
cd /www/admin_api/
## 初始化目录
php application/bin/install.php
## 修改配置文件
cp .env.test .env
vi .env 
## 修改ENVIRON的环境变量
## 初始化数据库
cd /data/www/admin_api

docker cp application/data/gamespeedup.sql PROXY_mariadb:/gamespeedup.sql

## application.ini 
## 把部署的新域名加到gamespeedup模块

## 更新配置文件权限$$
chmod 777 application/logs -R
```

```bash
## 进入数据库 执行sql文件
docker exec -it PROXY_mariadb sh
mysql -uroot -p < gamespeedup.sql

```
## 修改配置
```bash
修改proxy的nginx 中的域名 game.trojanshare.cc（server_name 和 Host 两处） 为当前部署的域名

最后拷贝新证书到 /data/gamespeedup-data/cert/ 目录下

```

### 更新geoip数据
https://github.com/Loyalsoldier/v2ray-rules-dat/

https://github.com/Loyalsoldier/v2ray-rules-dat/releases
## 开启crontab 脚本
```bash
# crontab -e
chmod +x /data/docker_compose/shell/check_resque.sh
1 0 * * * /data/docker_compose/shell/check_resque.sh
1 0 * * * /data/docker_compose/shell/crontab.sh
```

