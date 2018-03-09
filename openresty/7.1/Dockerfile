FROM tekintian/php:7.1
MAINTAINER TekinTian <tekintian@gmail.com>

ENV WEBSERVER_INSTALL_DIR=/usr/local/openresty \
    OPENRESTY_VERSION=1.11.2.2 \
    PCRE_VERSION=8.41 \
    OPENSSL_VERSION=1.1.1-pre2 \
    RUN_USER=www \
    WWWROOT_DIR=/home/wwwroot \
    WWWLOGS_DIR=/home/wwwlogs \
    REMOTE_PATH=https://github.com/tekintian/tengine-php/raw/master

WORKDIR /tmp

# install tengine
RUN wget -c --no-check-certificate ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
    tar xzf pcre-${PCRE_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf openresty-${OPENRESTY_VERSION}.tar.gz && \
    cd openresty-${OPENRESTY_VERSION} && \
    # close debug
    openresty_version_tmp=${OPENRESTY_VERSION%.*} && \
    sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' bundle/nginx-$openresty_version_tmp/auto/cc/gcc && \
    ./configure \
        --prefix=${WEBSERVER_INSTALL_DIR} \
        --user=${RUN_USER} --group=${RUN_USER} \
        --with-http_stub_status_module \
        --with-http_v2_module \
        --with-ipv6 \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_realip_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
        --with-pcre=/tmp/pcre-${PCRE_VERSION} \
        --with-pcre-jit \
        --with-ld-opt='-ljemalloc' && \
    make && make install && \
    rm -rf /tmp/*

# run install script
ADD ${REMOTE_PATH}/install.sh /tmp/install.sh
RUN chmod 777 install.sh && \
    bash install.sh && \
    rm -rf /tmp/*

# ending
WORKDIR ${WWWROOT_DIR}

# expose port
EXPOSE 80 443

# Set the entrypoint script.
ADD ${REMOTE_PATH}/entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define the default command.
CMD ["nginx", "-g", "daemon off;"]
