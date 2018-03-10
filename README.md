# tengine-php for docker , tengine + php5.4, php5.5, php5.6, php7.0, php7.1, php7.2 docker container
# php latest version
docker pull tekintian/tengine-php

## php-2.2.3
docker pull tekintian/tengine-php:2.2.3

## php-7.1.15
docker pull tekintian/tengine-php:7.1.15

## php-7.0.28
docker pull tekintian/tengine-php:7.0.28

##  php-5.6.34
docker pull tekintian/tengine-php:5.6.34

***
## description

  tengine-2.2.2  php-5.6.34, php-7.0.28, php-7.1.15, php-2.2.3
  last update 2018年03月10日09:32:46

  Tengine(Nginx) + php5.4, php5.5, php5.6, php7.0, php7.1, php7.2
  Tengine+ LuaJIT waf security module, IPV6, http2, OPENSSL 
  sphinx  + Memcached [Memcache]+ Redis + Swoole + Workman
   ImageMagick + ZendOpcache
  ZendGuardLoader + ionCube <php5.6 

## Tengine/nginx control
start|stop|status|restart|reload|configtest

docker exec -d web service nginx restart
php control
start|stop|restart|reload|status

docker exec -d web service php-fpm restart
***

# 使用示例

## 使用默认配置独立运行Tengine+php

1. 自定义配置运行命令

  docker run  -d -it \
  --name tengine  \
  --restart=always \
  -p 80:80 \
  -p 443:443 \
  -v /home/opt/tengine-php/vhost:/usr/local/tengine/conf/vhost  \
  -v /home/wwwroot:/home/wwwroot  \
  -v /home/wwwlogs:/home/wwwlogs \
  tekintian/tengine-php:latest

2. 简洁运行命令{just for test}：
  docker run -d -it --name tengine -p 80:80 -p 443:443 tekintian/tengine-php


### 文件夹说明
  默认主机 /home/wwwroot/default
  增加主机： 配置文件放到 /home/opt/tengine-php/vhost 文件夹， 网站文件放到本地 /home/wwwroot/ 文件夹下, 配置文件中的网站路径为  /home/wwwroot/xxx.com  

###参数解释
  以分号:分隔的运行参数，左边为需要镜像的主机的参数{可随意修改}， 分号右边为容器的参数{不可修改}

   -p 80:80
   分号左边为本地端口，右边为容器的端口

  ** -v Volume映射 **
    -v /home/xxx:/usr/local/tengine/conf
    在分号 : 左边的 /home/xxx为你本地主机的路径{可随意修改}，分号右边的的为容器的路径{不可修改}


***

# 与其他容器链接运行

** PS: 如果与其他容器链接运行，则必须先启动需要链接的容器后才能启动tengine ** 

## tengine + alisql + redis + memcached

# alisql

***

docker run --name myalisql -it -d \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=123456 \
    --restart=always \
    -v /home/opt/alisql/my.cnf:/usr/local/mysql/etc/my.cnf \
    -v /home/opt/alisql/data:/data/mysql/data \
    -v /home/opt/alisql/logs:/data/mysql/log \
    tekintian/alisql:latest


    注意将密码 123456 改为你自己的密码！

### 以交互方式登录 alisql
    docker exec -it myalisql mysql -uroot --password=123456

https://hub.docker.com/r/alisql/alisql/

# redis
***

docker run -d -it \
    --name myredis \
    --restart=always \
    -v /home/opt/redis/redis.conf:/usr/local/etc/redis/redis.conf  \
    redis

https://hub.docker.com/_/redis

# memcached
***

docker run -it -d --name mymemcache  --restart=always memcached  -m 64

This would set the memcache server to use 64 megabytes for storage.

--link mymemcache:memcache

https://hub.docker.com/_/memcache/

# tengine
***

  docker run  -d -it \
  --name tengine  \
  --link myalisql:mysql  \
  --link mymemcache:memcache \
  --link myredis:redis \
  --restart=always \
  -p 80:80 \
  -p 443:443 \
  -v /home/opt/tengine_conf:/usr/local/tengine/conf  \
  -v /home/opt/php72_etc:/usr/local/php/etc  \
  -v /home/opt/php72_log/var:/usr/local/php/var/log \
  -v /home/wwwroot:/home/wwwroot  \
  -v /home/wwwlogs:/home/wwwlogs \
  tekintian/tengine-php:7.2


## 本地路径
  /home/opt
  /home/wwwroot
  /home/wwwlogs

## Volume映射

  主机Volume | 容器Volume |  权限
  ---- | --- | --- 
  /home/wwwroot | /home/wwwroot | 读写
  /home/wwwlogs | /home/wwwlogs | 读写
  /home/opt/tengine/php_etc | /usr/local/php/etc  | 读写
  /home/opt/tengine/conf | /usr/local/tengine/conf | 读写


默认配置文件见 
https://github.com/tekintian/tengine-php/tree/master/src

Docker Container
https://hub.docker.com/r/tekintian/tengine-php/

****

##usage
### run with mysql latest
docker run --name mysql \
           -v /home/conf/mysql:/etc/mysql/conf.d \
           -v /home/mysql:/var/lib/mysql \
           -e MYSQL_ROOT_PASSWORD=123456 \
           -d mysql

docker run --name web \
           --link mysql:mysql \
           -v /home/conf/nginx:/usr/local/nginx/conf \
           -v /home/wwwlogs:/home/wwwlogs \
           -v /home/wwwroot:/home/wwwroot \
           -p 80:80 -p 443:443 \
           -d tekintian/tengine-php

###run didn't with mysql and run latest php version
docker run --name web \
           -v /home/wwwlogs:/home/wwwlogs \
           -v /home/wwwroot:/home/wwwroot \
           -p 80:80 -p 443:443 \
           -d tekintian/tengine-php:latest


## 查看日志

docker logs --tail=10 容器名称/ID

docker logs -f -t --since="2017-05-31" --tail=10 name 

--since : 此参数指定了输出日志开始日期，即只输出指定日期之后的日志。

-f : 查看实时日志

-t : 查看日志产生的日期

--tail=10 : 查看最后的10条日志。

name : 容器名称

