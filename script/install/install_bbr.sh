#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install bbr"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_support_docker $1
[ -n "$(lsmod|grep bbr)" ] && [ "$1" != "-f" ] && echo 'bbr installed' && exit 0
need curl

# Download && Run script.sh
cd \
    && curl -f#SL https://raw.githubusercontent.com/teddysun/across/master/bbr.sh -o bbr.sh \
    && $SUDO sh bbr.sh
rm -f bbr.sh

