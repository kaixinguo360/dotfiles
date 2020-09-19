#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove proxychains"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has proxychains && [ "$1" != "-f" ] && echo 'proxychains removeed' && exit 0
[ "$1" = "-f" ] && shift

# Remove proxychains
remove_pkg @!apk:proxychains @apk:proxychains-ng

# Print Help
echo "Removed."

exit 0
