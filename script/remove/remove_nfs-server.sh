#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove nfs-server"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has nfsdcltrack && [ "$1" != "-f" ] && echo 'nfs-server removeed' && exit 0
[ "$1" = "-f" ] && shift

# Cat configure of NFS-Serer
echo '----------------'
echo ' Current Config '
echo '----------------'
cat /etc/exports|grep -e '^\s*[^#].*$'
echo '----------------'

# Remove NFS-Server
remove_pkg nfs-kernel-server nfs-common

# Config UFW
has ufw && $sudo ufw delete allow 2049

exit 0
