#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove tinc"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has tincd && [ "$1" != "-f" ] && echo 'tinc removeed' && exit 0

# Remove tinc
remove_pkg tinc

# Remove config
printf 'Removing config... ' \
    && sudo rm -rf /etc/tinc \
    && printf 'done.\n'

# Close ports
close_port 655/tcp

# Print Help
echo "Removed."

exit 0

