#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install docker-compose"
    exit 0
fi

# Check Dependencies
has docker-compose && [ "$1" != "-f" ] && echo 'docker-compose installed' && exit 0
need curl

# Download
REMOTE="https://github.com/docker/compose/releases/download/1.26.0/run.sh"
[ "$PMG" = "apt" ] && { LOCAL=/usr/local/bin; }
[ "$PMG" = "termux" ] && { LOCAL=$PREFIX/bin; }
[ "$PMG" = "apk" ] && { LOCAL=/usr/local/bin; }

$SUDO curl -f#SL $REMOTE -o $LOCAL/docker-compose
$SUDO chmod +x $LOCAL/docker-compose

echo "Brook has been installed to $LOCAL/docker-compose"
echo "See 'docker-compose --help' to read help info."

