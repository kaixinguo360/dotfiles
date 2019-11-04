#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Check Dependencies
has rgit && [ "$1" != "-f" ] && echo 'rgit installed' && exit 0
need rsync wget

# Download && Run script.sh
cd \
    && wget -O get-rgit.sh https://github.com/kaixinguo360/Rgit/raw/master/sh/get-rgit.sh \
    && chmod +x get-rgit.sh \
    && $SUDO ./get-rgit.sh \
    && rm get-rgit.sh
