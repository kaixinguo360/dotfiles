#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install swarm-nfw-rules"
    exit 0
fi

# Expose ports
expose_port 2376/tcp
expose_port 2377/tcp
expose_port 7946/tcp
expose_port 7946/udp
expose_port 4789/udp

exit 0
