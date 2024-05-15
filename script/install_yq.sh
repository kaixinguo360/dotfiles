#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install yq"
    exit 0
fi

# Check Dependencies
has yq && [ "$1" != "-f" ] && echo 'yq installed' && exit 0
need curl unzip

# Set URL and Local Bin Path
if [ "$PMG" = "termux" ]; then
    LOCAL=$PREFIX/bin/yq
else
    LOCAL=/usr/local/bin/yq
fi
URL="https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"

# Download
download "$URL" "$LOCAL" 755 \
    && echo "yq has been installed to $LOCAL" \
    && echo "See 'yq --help' to read help info."

