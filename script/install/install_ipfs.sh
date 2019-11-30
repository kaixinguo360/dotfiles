#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install ipfs"
    exit 0
fi

# Check Dependencies
has ipfs && [ "$1" != "-f" ] && echo 'ipfs installed' && exit 0
need curl

# Static Parameters
[ "$PMG" = 'termux' ] && {
    RELEASE_URL=https://github.com/ipfs/go-ipfs/releases/download/v0.4.22/go-ipfs_v0.4.22_linux-arm64.tar.gz
    TARGET_PATH=$PREFIX/bin
} || {
    RELEASE_URL=https://github.com/ipfs/go-ipfs/releases/download/v0.4.22/go-ipfs_v0.4.22_linux-amd64.tar.gz
    TARGET_PATH=/usr/local/bin
}

# Download & Install & Init
curl -f#SL $RELEASE_URL | $SUDO tar \
    -C $TARGET_PATH \
    -zxv go-ipfs/ipfs \
    --strip-components 1 \
    || exit 1
ipfs init

[ "$PMG" = 'apt' ] && {
SYSTEM_D=/lib/systemd/system/ipfs.service
INIT_D=/etc/init.d/ipfs

$SUDO touch $SYSTEM_D $INIT_D
$SUDO chmod 777 $SYSTEM_D
$SUDO chmod 777 $INIT_D

cat > $SYSTEM_D << HERE
[Unit]
Description=Ipfs service written in Go.
After=syslog.target
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/home
ExecStart=/usr/local/bin/ipfs daemon
Restart=always

[Install]
WantedBy=multi-user.target
HERE
cat > $INIT_D << HERE
#! /bin/sh
### BEGIN INIT INFO
# Provides:          ipfs
# Required-Start:    \$syslog \$network
# Required-Stop:     \$syslog
# Should-Start:      mysql postgresql
# Should-Stop:       mysql postgresql
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Ipfs service written in Go.
# Description:       Ipfs service written in Go.
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="Ipfs service written in Go."
NAME=ipfs
SERVICEVERBOSE=yes
PIDFILE=/var/run/\$NAME.pid
SCRIPTNAME=/etc/init.d/\$NAME
WORKINGDIR=/home
DAEMON=ipfs
DAEMON_ARGS="deamon"
USER=$USER
HERE
cat $(dirname $0)/../../data/static/init-common >> $INIT_D

$SUDO chmod 644 $SYSTEM_D
$SUDO chmod 755 $INIT_D

$SUDO systemctl daemon-reload
$SUDO systemctl enable ipfs
$SUDO systemctl start ipfs

echo "Ipfs daemon is ready"
}
