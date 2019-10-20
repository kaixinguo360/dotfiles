#!/bin/bash

cd $(dirname $0)/../data
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install packages"
    exit 0
fi

# Read Package list
PACKAGES=$(cat packages.list)
echo "Content of the package.list:"
echo "  "$(echo "$PACKAGES")

# Install Packages
if [ -z "$PREFIX" ];then
    sudo apt update
    sudo apt install $PACKAGES -y
else # Termux
    apt update
    apt install wget -y
    wget https://its-pointless.github.io/setup-pointless-repo.sh \
        -O setup-pointless-repo.sh
    bash setup-pointless-repo.sh
    rm -f setup-pointless-repo.sh pointless.gpg
    apt install $PACKAGES -y
fi

