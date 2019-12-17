#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Check Dependencies
not_support_docker $1
has docker && [ "$1" != "-f" ] && echo 'docker installed' && exit 0
need curl

# Download && Run script.sh
cd \
    && curl -f#SL https://get.docker.com -o get-docker.sh \
    && $SUDO sh get-docker.sh
rm -f get-docker.sh

# Executing the Docker Command Without Sudo
[ -n "$USER" ] && $SUDO usermod -aG docker $USER
exit 0

