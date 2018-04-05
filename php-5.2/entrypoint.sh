#!/bin/sh
set -e

# reset memory
PHP_INSTALL_DIR=/usr/local
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

. /etc/profile
service php-fpm start

exec "$@"