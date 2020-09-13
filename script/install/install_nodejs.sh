#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install nodejs"
    exit 0
fi

# Check Dependencies
has node && [ "$1" != "-f" ] && echo 'nodejs installed' && exit 0

# Download && Run install script
download_and_run https://deb.nodesource.com/setup_12.x get-nodejs.sh \
    && $SUDO apt-get install -y nodejs

