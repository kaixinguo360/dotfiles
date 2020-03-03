#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install nodejs"
    exit 0
fi

# Check Dependencies
has node && [ "$1" != "-f" ] && echo 'nodejs installed' && exit 0
need curl

# Download && Run install script
cd \
    && curl -f#SL https://deb.nodesource.com/setup_12.x \
            -o get-nodejs.sh \
    && $SUDO bash get-nodejs.sh \
    && $SUDO apt-get install -y nodejs
rm -f get-nodejs.sh

