#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "$0 [-i] [TOOL] [OPTION]..."
    echo -e "Install tool"
    exit 0
fi

[ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }

# Termux
[[ -n "$@" && -n "$NEED_POINTLESS" ]] && {
    need wget bash apt
    wget https://its-pointless.github.io/setup-pointless-repo.sh -O setup-pointless-repo.sh
    bash setup-pointless-repo.sh
    rm -f setup-pointless-repo.sh pointless.gpg
}

install_tool $INTERACTIVE $@ || { echo "An error occured, stop installing of '$@'"; }

