FROM tekintian/php:7.0.30
LABEL maintainer="TekinTian tekintian@gmail.com"

ENV TENGINE_INSTALL_DIR=/usr/local/tengine \
    TENGINE_VERSION=2.2.3 \
    PCRE_VERSION=8.42 \
    OPENSSL_VERSION=1.1.0j \
    LuaJIT_VERSION=2.0.5 \
    LNM_VERSION=0.10.14rc3 \
    NDK_VERSION=0.3.1rc1 \
    RUN_USER=www \
    WWWROOT_DIR=/home/wwwroot \
    WWWLOGS_DIR=/home/wwwlogs \
    REMOTE_SRC_PATH=https://github.com/tekintian/tengine-php/raw/master

WORKDIR /tmp
#
#最新稳定版本openssl 
# https://www.openssl.org/source/openssl-1.1.0j.tar.gz
# https://www.openssl.org/source/snapshot/
#tengine http://tengine.taobao.org/download.html
# Luajit
# http://luajit.org/download.html
# http://luajit.org/download/LuaJIT-2.0.5.tar.gz
# https://github.com/openresty/lua-nginx-module/
# https://github.com/simplresty/ngx_devel_kit
#https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz
#WAF配置文件 https://github.com/loveshell/ngx_lua_waf
#pcre  ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre

#install build deps
RUN  buildDeps='\
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
                libgpgme11-dev \
                --no-install-recommends ' \
        && apt-get update && apt-get install -y ${buildDeps} && rm -rf /var/lib/apt/lists/*  && \
#LuaJIT. https://github.com/openresty/lua-nginx-module/archive/v0.10.12rc2.tar.gz
    wget -c --no-check-certificate http://luajit.org/download/LuaJIT-$LuaJIT_VERSION.tar.gz && \
    tar xzf LuaJIT-$LuaJIT_VERSION.tar.gz && \
    cd LuaJIT-$LuaJIT_VERSION && make && \
    make install PREFIX=/usr/local/luajit && \
    export LUAJIT_LIB=/usr/local/luajit/lib && export LUAJIT_INC=/usr/local/luajit/include/luajit-2.0 && \
    cd /tmp/ && \
# download related src
    wget -c --no-check-certificate https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz && \
    wget --no-check-certificate https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \

    wget -c --no-check-certificate https://github.com/openresty/lua-nginx-module/archive/v${LNM_VERSION}.tar.gz -O  lua-nginx-module-${LNM_VERSION}.tar.gz && \
    wget -c --no-check-certificate https://github.com/simplresty/ngx_devel_kit/archive/v${NDK_VERSION}.tar.gz -O ngx_devel_kit-${NDK_VERSION}.tar.gz && \

    wget -c --no-check-certificate http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz && \
    #解压
    tar xzf pcre-${PCRE_VERSION}.tar.gz && \
    tar xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    tar xzf lua-nginx-module-${LNM_VERSION}.tar.gz && \
    tar xzf ngx_devel_kit-${NDK_VERSION}.tar.gz && \
    tar xzf tengine-${TENGINE_VERSION}.tar.gz && \
# install tengine
    cd tengine-${TENGINE_VERSION} && \
    sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc && \
    ./configure \
        --prefix=${TENGINE_INSTALL_DIR} \
        --user=${RUN_USER} --group=${RUN_USER} \
        --add-module=/tmp/ngx_devel_kit-${NDK_VERSION} \
        --add-module=/tmp/lua-nginx-module-${LNM_VERSION} \
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
       # --with-http_lua_module  \
        --with-luajit-lib=/usr/local/luajit/lib/  \
        --with-luajit-inc=/usr/local/luajit/include/luajit-2.0/  \
        --with-ld-opt=-Wl,-rpath,/usr/local/luajit/lib  \
        --with-jemalloc && \
    make && make install && \
    mkdir -p ${TENGINE_INSTALL_DIR}/conf/rewrite && \
    mkdir -p ${TENGINE_INSTALL_DIR}/logs/hack && \
    #备份默认的配置文件
    cp -a ${TENGINE_INSTALL_DIR}/conf/nginx.conf ${TENGINE_INSTALL_DIR}/conf/nginx.conf.bak && \
     cd /tmp/ && rm -rf /tmp/* && \
    #remove build deps
    apt-get purge -y --auto-remove ${buildDeps}

ADD ${REMOTE_SRC_PATH}/nginx_waf.conf ${TENGINE_INSTALL_DIR}/conf/nginx.conf
ADD ${REMOTE_SRC_PATH}/nginx-init /etc/init.d/nginx
RUN sed -i "s@worker_connections 51200;@worker_connections 51200;\n    reuse_port on;@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf && \
    sed -i "s@^worker_processes.*@worker_processes auto;\nworker_cpu_affinity auto;\ndso {\n\tload ngx_http_concat_module.so;\n\tload ngx_http_sysguard_module.so;\n}@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf

# run install script
ADD ${REMOTE_SRC_PATH}/install_waf.sh /tmp/install_waf.sh
RUN chmod 777 install_waf.sh && \
    bash install_waf.sh && \
    rm -rf /tmp/*

# ending
WORKDIR ${WWWROOT_DIR}
RUN mkdir -p ${WWWLOGS_DIR} && \
    mkdir -p ${WWWROOT_DIR}/default && \
    echo "<?php phpinfo();" > /${WWWROOT_DIR}/default/index.php

# expose port
EXPOSE 80 443

# Set the entrypoint script.
ADD ${REMOTE_SRC_PATH}/entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Define the default command.
CMD ["nginx", "-g", "daemon off;"]