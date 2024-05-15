#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove yq"
    exit 0
fi

# Check Dependencies
not_has yq && [ "$1" != "-f" ] && echo 'yq not installed' && exit 0

# Set URL and Local Bin Path
if [ "$PMG" = "termux" ]; then
    LOCAL=$PREFIX/bin/yq
else
    LOCAL=/usr/local/bin/yq
fi

# Remove
echo -n "Removing yq... " \
    && $sudo rm -f "$LOCAL" \
    && echo "done."

