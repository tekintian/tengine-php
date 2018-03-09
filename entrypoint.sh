#!/bin/bash
set -e

# reset memory
PHP_INSTALL_DIR=/usr/local/php
Mem=`free -m | awk '/Mem:/{print $2}'`
if [ $Mem -le 640 ];then
    MEMORY_LIMIT=64
elif [ $Mem -gt 640 -a $Mem -le 1280 ];then
    MEMORY_LIMIT=128
elif [ $Mem -gt 1280 -a $Mem -le 2500 ];then
    MEMORY_LIMIT=192
elif [ $Mem -gt 2500 -a $Mem -le 3500 ];then
    MEMORY_LIMIT=256
elif [ $Mem -gt 3500 -a $Mem -le 4500 ];then
    MEMORY_LIMIT=320
elif [ $Mem -gt 4500 -a $Mem -le 8000 ];then
    MEMORY_LIMIT=384
elif [ $Mem -gt 8000 ];then
    MEMORY_LIMIT=448
fi

# optimize php-fpm
if [ $Mem -le 3000 ];then
    sed -i "s@^pm.max_children.*@pm.max_children = $(($Mem/3/20))@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.start_servers.*@pm.start_servers = $(($Mem/3/30))@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = $(($Mem/3/40))@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = $(($Mem/3/20))@" $PHP_INSTALL_DIR/etc/php-fpm.conf
elif [ $Mem -gt 3000 -a $Mem -le 4500 ];then
    sed -i "s@^pm.max_children.*@pm.max_children = 50@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.start_servers.*@pm.start_servers = 30@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = 20@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = 50@" $PHP_INSTALL_DIR/etc/php-fpm.conf
elif [ $Mem -gt 4500 -a $Mem -le 6500 ];then
    sed -i "s@^pm.max_children.*@pm.max_children = 60@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.start_servers.*@pm.start_servers = 40@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = 30@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = 60@" $PHP_INSTALL_DIR/etc/php-fpm.conf
elif [ $Mem -gt 6500 -a $Mem -le 8500 ];then
    sed -i "s@^pm.max_children.*@pm.max_children = 70@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.start_servers.*@pm.start_servers = 50@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = 40@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = 70@" $PHP_INSTALL_DIR/etc/php-fpm.conf
elif [ $Mem -gt 8500 ];then
    sed -i "s@^pm.max_children.*@pm.max_children = 80@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.start_servers.*@pm.start_servers = 60@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.min_spare_servers.*@pm.min_spare_servers = 50@" $PHP_INSTALL_DIR/etc/php-fpm.conf
    sed -i "s@^pm.max_spare_servers.*@pm.max_spare_servers = 80@" $PHP_INSTALL_DIR/etc/php-fpm.conf
fi

# optimize php.ini
sed -i "s@^memory_limit.*@memory_limit = ${MEMORY_LIMIT}M@" $PHP_INSTALL_DIR/etc/php.ini
if [ -f "$PHP_INSTALL_DIR/etc/php.d/ext-opcache.ini" ];then
    sed -i "s@^opcache.memory_consumption.*@opcache.memory_consumption=$MEMORY_LIMIT@" $PHP_INSTALL_DIR/etc/php.d/ext-opcache.ini
fi

source /etc/profile
service php-fpm start

exec "$@"
