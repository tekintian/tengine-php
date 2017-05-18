#!/bin/bash

[ -z "`grep ^'export PATH=' /etc/profile`" ] && echo "export PATH=$WEBSERVER_INSTALL_DIR/sbin:\$PATH" >> /etc/profile
[ -n "`grep ^'export PATH=' /etc/profile`" -a -z "`grep $WEBSERVER_INSTALL_DIR /etc/profile`" ] && sed -i "s@^export PATH=\(.*\)@export PATH=$WEBSERVER_INSTALL_DIR/sbin:\1@" /etc/profile

wget -c --no-check-certificate ${REMOTE_PATH}/nginx-init && mv -f nginx-init /etc/init.d/nginx
wget -c --no-check-certificate ${REMOTE_PATH}/nginx.conf && mv -f nginx.conf ${WEBSERVER_INSTALL_DIR}/conf/nginx.conf
wget -c --no-check-certificate ${REMOTE_PATH}/rewrite.tar.gz && tar -zxvf rewrite.tar.gz
mv -f rewrite ${WEBSERVER_INSTALL_DIR}/conf/ && unlink rewrite.tar.gz
mkdir -p ${WEBSERVER_INSTALL_DIR}/conf/vhost
chown -R root:staff ${WEBSERVER_INSTALL_DIR}/conf/

sed -i "s@/usr/local/nginx@$WEBSERVER_INSTALL_DIR@g" /etc/init.d/nginx
chmod +x /etc/init.d/nginx
ldconfig

# proxy.conf
cat > $WEBSERVER_INSTALL_DIR/conf/proxy.conf << EOF
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

sed -i "s@/home/wwwroot/default@$WWWROOT_DIR/default@" $WEBSERVER_INSTALL_DIR/conf/nginx.conf
sed -i "s@/home/wwwlogs@$WWWLOGS_DIR@g" $WEBSERVER_INSTALL_DIR/conf/nginx.conf
sed -i "s@^user www www@user $RUN_USER $RUN_USER@" $WEBSERVER_INSTALL_DIR/conf/nginx.conf

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

mkdir -p ${WWWROOT_DIR}/default ${WWWLOGS_DIR}
[ -d /home ] && chmod 755 /home
echo "Hello World! IT's running with PHP ${PHP_VERSION}!" > /${WWWROOT_DIR}/default/index.html
echo "<?php phpinfo();" > /${WWWROOT_DIR}/default/phpinfo.php