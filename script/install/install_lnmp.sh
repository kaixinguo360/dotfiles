#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install lnmp"
    exit 0
fi

# Check Dependencies
only apt
has nginx mysql php && [ "$1" != "-f" ] && echo 'lnmp installed' && exit 0
[ "$1" = "-f" ] && shift

# Read Input
read_input \
    SERVER_NAME str 'Domain name of this host' $DEFAULT_HOST_NAME \
    MYSQL_PASSWORD pass 'Root password of mysql?' $DEFAULT_PASSWORD \
    RUN_MYSQL_SECURE bool 'Run mysql_secure_installation?' n

# Static Params
PHP_CONF='/etc/php/7.0/fpm/php.ini'
NGINX_CONF='/etc/nginx/sites-enabled/default'
DEFAULT_NGINX_CONF="$ROOT_PATH/../data/static/nginx_site_config"

# Install
$SUDO debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
$SUDO debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"
install_tool lnmp.list

# Config MySQL
# run mysql_secure_installation (optional)
if [ "$RUN_MYSQL_SECURE" = "y" ]; then
    $SUDO mysql_secure_installation
fi

# Config PHP
$SUDO sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHP_CONF} -i

# Config Nginx
$SUDO cp $DEFAULT_NGINX_CONF $NGINX_CONF
$SUDO sed "s/TMP_SERVER_NAME/${SERVER_NAME}/g" ${NGINX_CONF} -i

# Start Service
start_service nginx restart
start_service php7.0-fpm restart
start_service mysql restart

# 测试安装结果
$SUDO bash -ic "echo '<?php phpinfo();' > /var/www/html/info.php"
echo -e '\n安装完成!'
echo "您可以打开 http://${SERVER_NAME}/info.php 来检查安装结果"
echo "(建议检查完后删除info.php以增强安全性)"
