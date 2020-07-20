#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install lnmp"
    exit 0
fi

# Check Dependencies
only_support $1 apt
has nginx mysql php && [ "$1" != "-f" ] && echo 'lnmp installed' && exit 0
[ "$1" = "-f" ] && shift

# Read Input
read_input \
    LNMP_HOST_NAME str '[1/3] Domain name of this host' $DEFAULT_HOST_NAME \
    LNMP_MYSQL_PASSWORD pass '[2/3] Root password of mysql' $DEFAULT_PASSWORD \
    LNMP_RUN_MYSQL_SECURE bool '[3/3] Run mysql_secure_installation?' n

# Static Params
PHP_CONF='/etc/php/7.0/fpm/php.ini'
NGINX_CONF='/etc/nginx/sites-enabled/default'
DEFAULT_NGINX_CONF="$ROOT_PATH/../data/snippets/nginx_site_config"

# Install
$SUDO debconf-set-selections <<< "mysql-server mysql-server/root_password password $LNMP_MYSQL_PASSWORD"
$SUDO debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $LNMP_MYSQL_PASSWORD"
install_tool lnmp.list || { echo "LNMP installation failed"; exit 1; }

# Config MySQL
# run mysql_secure_installation (optional)
if [ "$LNMP_RUN_MYSQL_SECURE" = "y" ]; then
    $SUDO mysql_secure_installation
fi

# Config PHP
$SUDO sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHP_CONF} -i

# Config Nginx
$SUDO cp $DEFAULT_NGINX_CONF $NGINX_CONF
$SUDO sed "s/TMP_SERVER_NAME/${LNMP_HOST_NAME}/g" ${NGINX_CONF} -i

# Start Service
start_service nginx restart
start_service php7.0-fpm restart
start_service mysql restart

# 测试安装结果
$SUDO bash -ic "echo '<?php phpinfo();' > /var/www/html/info.php"
echo -e '\n安装完成!'
echo "您可以打开 http://${LNMP_HOST_NAME}/info.php 来检查安装结果"
echo "(建议检查完后删除info.php以增强安全性)"

