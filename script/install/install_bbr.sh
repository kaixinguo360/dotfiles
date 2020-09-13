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

# Download & Run
download_and_run \
    https://github.com/teddysun/across/raw/master/bbr.sh \
    bbr.sh

