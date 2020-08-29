#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install swarm-nfw-rules"
    exit 0
fi

# Config UFW
has ufw && {
    $sudo ufw delete allow 2376/tcp
    $sudo ufw delete allow 2377/tcp
    $sudo ufw delete allow 7946/tcp
    $sudo ufw delete allow 7946/udp
    $sudo ufw delete allow 4789/udp 
    $sudo ufw reload
}

exit 0
