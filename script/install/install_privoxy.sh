#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install privoxy"
    exit 0
fi

# Check Dependencies
not_support $1 termux
has privoxy && [ "$1" != "-f" ] && echo 'privoxy installed' && exit 0
[ "$1" = "-f" ] && shift

# Install privoxy
install_pkg privoxy

# Print Help
cat << HERE
------------------------
       - Help -
------------------------
Example config:
  forward-socks5 / 127.0.0.1:1080 .    # forward socks5 proxy
  listen-address 0.0.0.0:8080        # local port
------------------------
Eample commands:
  $SUDO vi /etc/privoxy/config     # edit config file
  $SUDO service privoxy restart    # reload service
  curl google.com --proxy http://127.0.0.1:8080    # test
------------------------
HERE

exit 0
