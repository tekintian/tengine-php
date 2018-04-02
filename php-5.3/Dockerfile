FROM magentoomitsis/php5.3:latest
MAINTAINER Tekin Tian <tekintian@gmail.com>

ENV TENGINE_INSTALL_DIR=/usr/local/tengine \
    TENGINE_VERSION=2.2.2 \
    PCRE_VERSION=8.41 \
    OPENSSL_VERSION=1.1.1-pre2 \
    RUN_USER=www-data \
    WWWROOT_DIR=/home/wwwroot \
    WWWLOGS_DIR=/home/wwwlogs \
    REMOTE_SRC_PATH=https://github.com/tekintian/tengine-php/raw/master

WORKDIR /tmp

# install tengine
RUN apt-get install -y  bzip2 && \
    wget http://mirrors.linuxeye.com/oneinstack/src/jemalloc-4.4.0.tar.bz2 && \
    tar -xjf jemalloc-4.4.0.tar.bz2 && \
    cd jemalloc-4.4.0 && \
    ./configure --prefix=/usr/local/jemalloc --libdir=/usr/local/lib && \
    make && make install && \
    make clean && \
    cd /tmp/ && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf && \
    /sbin/ldconfig 

RUN  wget -c --no-check-certificate ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    wget -c --no-check-certificate http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz && \
    tar xzf pcre-${PCRE_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf tengine-${TENGINE_VERSION}.tar.gz && \
    cd tengine-${TENGINE_VERSION} && \
    # Modify Tengine version
    #sed -i 's@TENGINE "/" TENGINE_VERSION@"nginx/unknown"@' src/core/nginx.h && \
    # close debug
    sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc && \
    ./configure \
        --prefix=${TENGINE_INSTALL_DIR} \
        --user=${RUN_USER} --group=${RUN_USER} \
        --with-http_v2_module \
        --with-http_ssl_module \
        --with-ipv6 \
        --with-http_gzip_static_module \
        --with-http_realip_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_concat_module=shared \
        --with-http_sysguard_module=shared \
        --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
        --with-pcre=/tmp/pcre-${PCRE_VERSION} \
        --with-pcre-jit \
        --with-jemalloc && \
    make && make install && \
    mkdir -p ${TENGINE_INSTALL_DIR}/conf/rewrite && \
    touch ${TENGINE_INSTALL_DIR}/conf/rewrite/none.conf && \
    rm -rf /tmp/* && \
    apt-get remove -y bzip2 && \
    apt-get autoremove -y

ADD nginx.conf ${TENGINE_INSTALL_DIR}/conf/nginx.conf
ADD nginx-init /etc/init.d/nginx
RUN sed -i "s@worker_connections 51200;@worker_connections 51200;\n    reuse_port on;@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf && \
    sed -i "s@^worker_processes.*@worker_processes auto;\nworker_cpu_affinity auto;\ndso {\n\tload ngx_http_concat_module.so;\n\tload ngx_http_sysguard_module.so;\n}@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf

# run install script
ADD ${REMOTE_SRC_PATH}/install.sh /tmp/install.sh
RUN chmod 777 install.sh && \
    bash install.sh && \
    rm -rf /tmp/*

# ending
WORKDIR ${WWWROOT_DIR}
RUN mkdir -p ${WWWLOGS_DIR} && \
    mkdir -p ${WWWROOT_DIR}/default && \
    echo "Hello World!" > /${WWWROOT_DIR}/default/index.html && \
    echo "<?php phpinfo();" > /${WWWROOT_DIR}/default/phpinfo.php

# expose port
EXPOSE 80 443

# Set the entrypoint script.
ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define the default command.
CMD ["nginx", "-g", "daemon off;"]