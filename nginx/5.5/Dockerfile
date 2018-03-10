FROM tekintian/php:5.5
MAINTAINER TekinTian <tekintian@gmail.com>

ENV WEBSERVER_INSTALL_DIR=/usr/local/nginx \
    NGINX_VERSION=1.13.9 \
    PCRE_VERSION=8.41 \
    OPENSSL_VERSION=1.0.2n \
    RUN_USER=www \
    WWWROOT_DIR=/home/wwwroot \
    WWWLOGS_DIR=/home/wwwlogs \
    REMOTE_PATH=https://github.com/tekintian/tengine-php/raw/master

WORKDIR /tmp

# install tengine
RUN wget -c --no-check-certificate ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    wget -c --no-check-certificate http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf pcre-${PCRE_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    # Modify Nginx version
    #sed -i 's@#define NGINX_VERSION.*$@#define NGINX_VERSION      "1.2"@' src/core/nginx.h
    #sed -i 's@#define NGINX_VER.*NGINX_VERSION$@#define NGINX_VER          "nginx/" NGINX_VERSION@' src/core/nginx.h
    #sed -i 's@Server: nginx@Server: unknow@' src/http/ngx_http_header_filter_module.c
    # close debug
    sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc && \
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
