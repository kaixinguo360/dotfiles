#!/bin/bash

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Read Package list
cd && wget -O get-rgit.sh https://github.com/kaixinguo360/Rgit/raw/master/sh/get-rgit.sh && chmod +x get-rgit.sh

# Install Packages
if [ -z "$PREFIX" ];then
    sudo ./get-rgit.sh
else # Termux
    ./get-rgit.sh
fi

rm get-rgit.sh
