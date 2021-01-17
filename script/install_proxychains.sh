#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install proxychains"
    exit 0
fi

# Check Dependencies
not_support $1 termux
has proxychains && [ "$1" != "-f" ] && echo 'proxychains installed' && exit 0
[ "$1" = "-f" ] && shift

# Install proxychains
install_pkg \
    @!apk:proxychains \
    @apk:proxychains-ng

# Print Help
echo -e "Example config: socks5 127.0.0.1 1080"
echo -e "Now you should edit /etc/proxychains.conf to add your proxy server\n"
echo -e "  $SUDO vi /etc/proxychains.conf\n"
exit 0
