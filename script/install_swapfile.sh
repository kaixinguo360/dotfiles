#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install swapfile"
    exit 0
fi

# Check Dependencies
only_support apt
[ -n "$(swapon)" ] && [ "$1" != "-f" ] && echo 'swapfile installed' && exit 0

# Read Input
read_input \
    SWAPFILE_SIZE str '[1/1] Size of new swapfile (GB)' '2'

# Create swapfule
$sudo dd if=/dev/zero of=/swapfile count=$((1024*$SWAPFILE_SIZE)) bs=1MiB
$sudo chmod 600 /swapfile
$sudo mkswap /swapfile

# Enable swapfile
$sudo swapon /swapfile

# Add swapfile to /etc/fstab
$sudo cp /etc/fstab /etc/fstab.bak
$sudo sed -i '/^\s*\/swapfile\s\+[^ ]\+\s\+swap.*$/d' /etc/fstab
$sudo bash -c "echo '/swapfile swap swap defaults 0 0' >> /etc/fstab "

# Print tips
echo -e "Maybe you should reboot this machine, use this command:\n"
echo -e "  $sudo reboot\n"
