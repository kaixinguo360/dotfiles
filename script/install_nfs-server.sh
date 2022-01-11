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


# -------------------- #

# Lock Port of mountd, nlockmgr and status
# Reference: https://blog.csdn.net/bryanwang_3099/article/details/114702374

# Config Port of `status` Service to 40000
if [ -z "$(grep -E 'STATDOPTS=".*--port .*"' /etc/default/nfs-common)" ]; then
    $sudo sed -i -E 's/^\s*STATDOPTS="(.*)"$/STATDOPTS="\1 --port 40000"/g' /etc/default/nfs-common
else
    $sudo sed -i -E 's/^\s*STATDOPTS="(.*)--port\s*[^ ]*(.*)"$/STATDOPTS="\1--port 40000\2"/g' /etc/default/nfs-common
fi

# Config Port of `mountd` Service to 40001
if [ -z "$(grep -E 'RPCMOUNTDOPTS=".* -p .*"' /etc/default/nfs-kernel-server)" ]; then
    $sudo sed -i -E 's/^\s*RPCMOUNTDOPTS="(.*)"$/RPCMOUNTDOPTS="\1 -p 40001"/g' /etc/default/nfs-kernel-server
else
    $sudo sed -i -E 's/^\s*RPCMOUNTDOPTS="(.*)-p\s*[^ ]*(.*)"$/RPCMOUNTDOPTS="\1-p 40001\2"/g' /etc/default/nfs-kernel-server
fi

# Config Port of `nlockmgr` Service to 40002
$sudo touch /etc/modprobe.d/options.conf
$sudo chmod 666 /etc/modprobe.d/options.conf
printf '%s\n' 'options lockd nlm_udpport=40002 nlm_tcpport=40002' > /etc/modprobe.d/options.conf
$sudo chmod 644 /etc/modprobe.d/options.conf

if [ -z "$(grep -E '^\s*lockd\s*$' /etc/modules)" ]; then
    $sudo chmod 666 /etc/modules
    printf '%s\n' 'lockd' >> /etc/modules
    $sudo chmod 644 /etc/modules
fi

# -------------------- #


# Restart nfs Service
restart_service portmap
restart_service nfs-kernel-server

# Expose ports
expose_port 2049    # nfs
expose_port 111     # portmapper
expose_port 40000   # status
expose_port 40001   # mountd
expose_port 40002   # nlockmgr

# Info
cat << HERE

You should reboot this server to apply port change.

HERE

exit 0
