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
    && $SUDO sh get-rgit.sh
rm -f get-rgit.sh
