#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove privoxy"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has privoxy && [ "$1" != "-f" ] && echo 'privoxy removeed' && exit 0
[ "$1" = "-f" ] && shift

# Remove privoxy
remove_pkg privoxy

# Print Help
echo "Removed."

exit 0

