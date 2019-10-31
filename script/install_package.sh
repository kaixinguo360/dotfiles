#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install packages"
    exit 0
fi

# Termux
if [ -n "$TERMUX" ];then
    install_pkg wget bash
    wget https://its-pointless.github.io/setup-pointless-repo.sh -O setup-pointless-repo.sh
    bash setup-pointless-repo.sh
    rm -f setup-pointless-repo.sh pointless.gpg
fi

install_pkg $(pkg_list)

