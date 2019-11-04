#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Check Dependencies
[ -n "$(has docker)" ] && return 0
need curl

# Download get-docker.sh
cd
curl -fsSL https://get.docker.com -o get-docker.sh
$SUDO sh get-docker.sh
rm -f get-docker.sh

# Executing the Docker Command Without Sudo
[ -n "$USER" ] && $SUDO usermod -aG docker $USER

