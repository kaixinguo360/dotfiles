#!/bin/bash

cd $(dirname $0)/../data
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install packages"
    exit 0
fi

# Install
PACKAGES=$(cat packages.list)
echo "Content of the package.list:"
echo "  "$(echo "$PACKAGES")
CMD="apt install $PACKAGES -y"
if [ -z "$PREFIX" ];then # Termux
    CMD="sudo "$CMD
fi
$CMD
