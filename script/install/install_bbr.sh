#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install bbr"
    exit 0
fi

# Check Dependencies
only apt
[ -n "$(lsmod|grep bbr)" ] && [ "$1" != "-f" ] && echo 'bbr installed' && exit 0
need curl

# Download && Run script.sh
cd \
    && curl -fsSL https://raw.githubusercontent.com/teddysun/across/master/bbr.sh -o bbr.sh \
    && $SUDO sh bbr.sh \
    && rm -f bbr.sh

