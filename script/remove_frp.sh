#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove frp"
    exit 0
fi

# Check Dependencies
not_has frpc && [ "$1" != "-f" ] && echo 'frp not installed' && exit 0

# Set Local Bin and Etc Path
if [ "$PMG" = "termux" ]; then
    BIN_LOCAL=$PREFIX/bin
    ETC_LOCAL=$PREFIX/etc
else
    BIN_LOCAL=/usr/local/bin
    ETC_LOCAL=/etc
fi

# Remove
echo -n "Removing frp... " \
    && $sudo rm -f "$BIN_LOCAL/frpc" \
    && $sudo rm -f "$BIN_LOCAL/frps" \
    && $sudo rm -rf "$ETC_LOCAL/frp" \
    && echo "done."

