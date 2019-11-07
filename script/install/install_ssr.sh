#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Check Dependencies
python3 -c "import shadowsocks" >/dev/null 2>&1 \
    && [ "$1" != "-f" ] && echo 'rgit installed' && exit 0
need python3.list

# Download && Install
pip3 install https://github.com/ToyoDAdoubiBackup/shadowsocksr/archive/manyuser.zip

