#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Install rsync
install_pkg rsync

# Read Package list
cd && wget -O get-rgit.sh https://github.com/kaixinguo360/Rgit/raw/master/sh/get-rgit.sh && chmod +x get-rgit.sh

$SUDO ./get-rgit.sh

rm get-rgit.sh
