FROM tekintian/php:5.2.17
LABEL maintainer="TekinTian tekintian@gmail.com"

ENV TENGINE_INSTALL_DIR=/usr/local/tengine \
    TENGINE_VERSION=2.2.3 \
    PCRE_VERSION=8.42 \
<<<<<<< HEAD
    OPENSSL_VERSION=1.0.2o \
    RUN_USER=www-data \
=======
    OPENSSL_VERSION=1.1.0j \
    RUN_USER=www \
>>>>>>> origin/master
    WWWROOT_DIR=/home/wwwroot \
    WWWLOGS_DIR=/home/wwwlogs \
    REMOTE_SRC_PATH=https://github.com/tekintian/tengine-php/raw/master

WORKDIR /tmp

#install build deps
RUN  buildDeps='\
<<<<<<< HEAD
                gcc \
                g++ \
                make \
                cmake \
                autoconf \
                libssl-dev \
                libcurl4-openssl-dev \
                libxslt-dev \
                libicu-dev \
                libxml2-dev \
                libjpeg-dev \
                libpng-dev \
                libfreetype6-dev \
                libsasl2-dev \
                libevent-dev \
                libpcre3-dev \
                libgpgme11-dev \
                pkg-config \
                patch \
                bzip2 \
                libgpgme11-dev \
                --no-install-recommends ' \
        && apt-get update && apt-get install -y wget ${buildDeps} && rm -rf /var/lib/apt/lists/*  && \
# install tengine
    wget -c --no-check-certificate  https://github.com/jemalloc/jemalloc/archive/stable-4.tar.gz -O jemalloc-stable-4.tar.gz && \
    tar -xjf jemalloc-stable-4.tar.gz && \
    cd jemalloc-stable-4 && \
    ./configure --prefix=/usr/local/jemalloc --libdir=/usr/local/lib && \
    make && make install && \
=======
        gcc \
        g++ \
        make \
        cmake \
        autoconf \
        libssl-dev \
        libcurl4-openssl-dev \
        libxslt-dev \
        libicu-dev \
        libxml2-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libsasl2-dev \
        libevent-dev \
        libpcre3-dev \
        libgpgme11-dev \
        pkg-config \
        patch \
        bzip2 \
        libgpgme11-dev \
        automake \
        m4 \
        perl \
        --no-install-recommends ' \
    && apt-get update && apt-get install -y wget procps unzip bzip2 psmisc ${buildDeps} && rm -rf /var/lib/apt/lists/*  && \
# install tengine
    wget -c --no-check-certificate  https://github.com/jemalloc/jemalloc/archive/stable-4.tar.gz -O jemalloc-stable-4.tar.gz && \
    tar -zxvf jemalloc-stable-4.tar.gz  && \
    cd /tmp/jemalloc-stable-4 && \
    autoconf && \
    ./configure --prefix=/usr/local/jemalloc --libdir=/usr/local/lib && \
    make && make install_bin install_include install_lib && \
>>>>>>> origin/master
    cd /tmp/ && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf && \
    /sbin/ldconfig  && \
    #PCre
<<<<<<< HEAD
=======
    cd /tmp/ && \
>>>>>>> origin/master
    wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    wget -c --no-check-certificate http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz && \
    tar xzf pcre-${PCRE_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf tengine-${TENGINE_VERSION}.tar.gz && \
    cd tengine-${TENGINE_VERSION} && \
    # Modify Tengine version
<<<<<<< HEAD
    #sed -i 's@TENGINE "/" TENGINE_VERSION@"nginx/unknown"@' src/core/nginx.h && \
    # close debug
    sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc && \
=======
    sed -i 's@TENGINE "/" TENGINE_VERSION@"nginx/unknown"@' src/core/nginx.h && \
    # close debug
   # sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc && \
>>>>>>> origin/master
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
    cd /tmp/ && rm -rf /tmp/* && \
    #remove build deps
    apt-get purge -y --auto-remove ${buildDeps}

ADD nginx.conf ${TENGINE_INSTALL_DIR}/conf/nginx.conf
ADD nginx-init /etc/init.d/nginx
RUN sed -i "s@worker_connections 51200;@worker_connections 51200;\n    reuse_port on;@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf && \
    sed -i "s@^worker_processes.*@worker_processes auto;\nworker_cpu_affinity auto;\ndso {\n\tload ngx_http_concat_module.so;\n\tload ngx_http_sysguard_module.so;\n}@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf

# run install script
<<<<<<< HEAD
ADD ${REMOTE_SRC_PATH}/install.sh /tmp/install.sh
=======
ADD install.sh /tmp/install.sh
>>>>>>> origin/master
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