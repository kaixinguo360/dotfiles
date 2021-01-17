#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove nfs-clinet"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has nfsstat && [ "$1" != "-f" ] && echo 'nfs-clinet removeed' && exit 0
[ "$1" = "-f" ] && shift


# Remove NFS-Server
remove_pkg nfs-common

# Print Help
[ -n "$(grep nfs /etc/fstab)" ] && {
    echo '---------------------'
    grep nfs /etc/fstab --color
    echo '---------------------'
    echo -e "Now you should open /etc/fstab to remove above nfs items:\n"
    echo -e " $SUDO vi /etc/fstab\n"
}

exit 0
