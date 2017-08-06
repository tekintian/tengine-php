#tengine-php for docker

docker pull tekintian/tengine-php:7.0

tengine + php 7.0.22


## description

Nginx(Tengine) + PHP 7.1.x
ImageMagick + ZendOpcache
Memcache + Memcached + Redis
ZendGuardLoader + ionCube
Swoole + Workman

##usage

### run alone; share folder is /mywork

docker run --name tengine-php -it -d \
 -p 80:80 -p 443:443 \
 -v /mywork/wwwroot:/home/wwwroot \
 -v /mywork/wwwlogs:/home/wwwlogs \
 -v /mywork/vhost/nginx.conf:/usr/local/tengine/conf/nginx.conf \
 -v /mywork/vhost/tengine:/usr/local/tengine/conf/vhost \
 --restart=always \
 tekintian/tengine-php:7.0

### run with  windows10 docker container  /E/mywork/ 为DOCKER容器共享后的宿主机 E盘下的mywork目录

docker run --name tengine-php -it -d  -p 80:80 -p 443:443 -v /E/mywork/wwwroot:/home/wwwroot -v /E/mywork/logs:/home/wwwlogs -v /E/mywork/vhost/nginx.conf:/usr/local/tengine/conf/nginx.conf -v /E/mywork/vhost/tengine:/usr/local/tengine/conf/vhost --restart=always tekintian/tengine-php:7.0




### run with mysql
docker run --name mysql \
           -v /home/conf/mysql:/etc/mysql/conf.d \
           -v /home/mysql:/var/lib/mysql \
           -e MYSQL_ROOT_PASSWORD=my-secret-pw \
           -d mysql
docker run --name web \
           --link mysql:localmysql \
           -v /home/conf/nginx:/usr/local/nginx/conf \
           -v /home/wwwlogs:/home/wwwlogs \
           -v /home/wwwroot:/home/wwwroot \
           -p 80:80 -p 443:443 \
           -d tekintian/tengine-php

###run didn't with mysql
docker run --name web \
           -v /home/wwwlogs:/home/wwwlogs \
           -v /home/wwwroot:/home/wwwroot \
           -p 80:80 -p 443:443 \
           -d tekintian/tengine-php
##nginx control
start|stop|status|restart|reload|configtest

docker exec -d web service nginx restart
php control
start|stop|restart|reload|status

docker exec -d web service php-fpm restart



for more info

http://tekin.yunnan.ws

