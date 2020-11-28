#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install encfs"
    exit 0
fi

# Check Dependencies
only_support $1 apt
has nfsstat && [ "$1" != "-f" ] && echo 'encfs installed' && exit 0
[ "$1" = "-f" ] && shift

# Read Input
DEFAULT_MOUNT_DIR="/mnt/encfs"
read_input \
    MOUNT_DIR str '[1/1] Mount directory' $DEFAULT_MOUNT_DIR \

# Install EncFS
install_pkg encfs

# Create mount directory
echo -n "Create mount directory '$MOUNT_DIR'... " \
    && $sudo mkdir -p "$MOUNT_DIR" \
    && $sudo chown nobody:nogroup "$MOUNT_DIR" \
    && echo 'done.'

# Print Help
echo -e "Now you can use this command to mount nfs to $MOUNT_DIR\n"
echo -e "  $SUDO mount -t nfs <ip>:<path> $MOUNT_DIR\n"
exit 0
