#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove rclone"
    exit 0
fi

# Check Dependencies
not_has rclone && [ "$1" != "-f" ] && echo 'rclone not installed' && exit 0

# Set URL and Local Bin Path
if [ "$PMG" = "termux" ]; then
    LOCAL=$PREFIX/bin/rclone
else
    LOCAL=/usr/local/bin/rclone
fi

# Remove
echo -n "Removing rclone... " \
    && $sudo rm -f "$LOCAL" \
    && echo "done."

