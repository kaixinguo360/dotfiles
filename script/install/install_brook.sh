#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install brook"
    exit 0
fi

# Check Dependencies
has brook && [ "$1" != "-f" ] && echo 'brook installed' && exit 0
need curl

# Download
URL="https://github.com/txthinking/brook/releases/download/v20190601/brook_linux_"
[ "$PMG" = "apt" ] && { REMOTE="${URL}386"; LOCAL=/usr/local/bin; }
[ "$PMG" = "termux" ] && { REMOTE="${URL}arm64"; LOCAL=$PREFIX/bin; }
[ "$PMG" = "apk" ] && { REMOTE="${URL}386"; LOCAL=/usr/local/bin; }

$SUDO curl -f#SL $REMOTE -o $LOCAL/brook
$SUDO chmod +x $LOCAL/brook

echo "Brook has been installed to $LOCAL/brook"
echo "See 'brook --help' to read help info."

