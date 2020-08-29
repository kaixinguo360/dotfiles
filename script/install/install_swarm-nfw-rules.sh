#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install swarm-nfw-rules"
    exit 0
fi

# Config UFW
has ufw && {
    $sudo ufw allow 2376/tcp
    $sudo ufw allow 2377/tcp
    $sudo ufw allow 7946/tcp
    $sudo ufw allow 7946/udp
    $sudo ufw allow 4789/udp 
    $sudo ufw reload
}

exit 0
