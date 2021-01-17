#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install nfs-server"
    exit 0
fi

# Check Dependencies
only_support $1 apt
has nfsdcltrack && [ "$1" != "-f" ] && echo 'nfs-server installed' && exit 0
[ "$1" = "-f" ] && shift

# Read Input
DEFAULT_SHARE_DIR="/srv/nfs"
read_input \
    SHARE_DIR str '[1/1] Share directory' $DEFAULT_SHARE_DIR \

# Install NFS-Server
install_pkg nfs-kernel-server

# Create share directory
echo -n "Create share directory '$SHARE_DIR'... " \
    && $sudo mkdir -p "$SHARE_DIR" \
    && $sudo chown nobody:nogroup "$SHARE_DIR" \
    && echo 'done.'

# Config NFS-Server
$sudo sed -i "/^$(echo $SHARE_DIR|sed 's#/#\\/#g')/d" /etc/exports
$sudo bash -c "echo '$SHARE_DIR *(rw,sync,no_root_squash,no_subtree_check)' >> /etc/exports"
restart_service nfs-kernel-server

# Expose ports
expose_port 2049

exit 0
