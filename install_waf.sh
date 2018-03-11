#!/bin/bash
#
TENGINE_INSTALL_DIR=/usr/local/tengine

mkdir -p ${WWWROOT_DIR}/default ${WWWLOGS_DIR}
[ -d /home ] && chmod 755 /home
echo "Hello World! IT's running with PHP ${PHP_VERSION}! <hr> <br> <a href='/luatest'>LUA test</a> <br> <a href='/adminer.php'>Adminer</a> <br> <a href='/tz.php'>tz</a>" > /${WWWROOT_DIR}/default/index.html
echo "<?php phpinfo();" > /${WWWROOT_DIR}/default/phpinfo.php


[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=${TENGINE_INSTALL_DIR}/sbin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep ${TENGINE_INSTALL_DIR} /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=${TENGINE_INSTALL_DIR}/sbin:\1@" /etc/profile

wget -c --no-check-certificate ${REMOTE_SRC_PATH}/nginx-init && mv -f nginx-init /etc/init.d/nginx
#wget -c --no-check-certificate ${REMOTE_SRC_PATH}/nginx_waf.conf && mv -f nginx_waf.conf ${TENGINE_INSTALL_DIR}/conf/nginx.conf
wget -c --no-check-certificate  -P ${WWWROOT_DIR}/default/ ${REMOTE_SRC_PATH}/src/tz.php
wget -c --no-check-certificate  -P ${WWWROOT_DIR}/default/ ${REMOTE_SRC_PATH}/src/adminer.php
wget -c --no-check-certificate ${REMOTE_SRC_PATH}/rewrite.tar.gz && tar -zxvf rewrite.tar.gz
mv -f rewrite ${TENGINE_INSTALL_DIR}/conf/ && unlink rewrite.tar.gz

wget -c --no-check-certificate ${REMOTE_SRC_PATH}/src/waf.tar.gz && tar -zxvf waf.tar.gz
mv -f waf/ ${TENGINE_INSTALL_DIR}/conf/ && unlink waf.tar.gz

mkdir -p ${TENGINE_INSTALL_DIR}/conf/vhost
chown -R root:staff ${TENGINE_INSTALL_DIR}/conf/
chown -R ${RUN_USER}:${RUN_USER} ${TENGINE_INSTALL_DIR}/logs/ 

sed -i "s@/usr/local/nginx@${TENGINE_INSTALL_DIR}@g" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
ldconfig

# proxy.conf
cat > ${TENGINE_INSTALL_DIR}/conf/proxy.conf << EOF
proxy_connect_timeout 300s;
proxy_send_timeout 900;
proxy_read_timeout 900;
proxy_buffer_size 32k;
proxy_buffers 4 64k;
proxy_busy_buffers_size 128k;
proxy_redirect off;
proxy_hide_header Vary;
proxy_set_header Accept-Encoding '';
proxy_set_header Referer \$http_referer;
proxy_set_header Cookie \$http_cookie;
proxy_set_header Host \$host;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
EOF

sed -i "s@/home/wwwroot/default@$WWWROOT_DIR/default@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf
sed -i "s@/home/wwwlogs@$WWWLOGS_DIR@g" ${TENGINE_INSTALL_DIR}/conf/nginx.conf
sed -i "s@^user www www@user $RUN_USER $RUN_USER@" ${TENGINE_INSTALL_DIR}/conf/nginx.conf

# logrotate nginx log
cat > /etc/logrotate.d/nginx << EOF
$WWWLOGS_DIR/*nginx.log {
  daily
  rotate 5
  missingok
  dateext
  compress
  notifempty
  sharedscripts
  postrotate
    [ -e /var/run/nginx.pid ] && kill -USR1 \`cat /var/run/nginx.pid\`
  endscript
}
EOF

