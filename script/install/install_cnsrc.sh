#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Change China Source"
    exit 0
fi

# Check Dependencies
only_support $1 apt termux apk

# apt
[ "$PMG" = "apt" ] && {
cd /etc/apt
$SUDO cp sources.list sources.list.bak
$SUDO cat > sources.list << HERE
deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main

deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main

deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe

deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe
HERE
$SUDO apt update -qq
echo "Change apt source to 'mirrors.aliyun.com'"
exit 0
}

# termux
[ "$PMG" = "termux" ] && {
cd $PREFIX/etc/apt
cp sources.list sources.list.bak
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux stable main@' \
    $PREFIX/etc/apt/sources.list
apt update -qq
echo "Change termux source to 'mirrors.tuna.tsinghua.edu.cn'"
exit 0
}

# apk
[ "$PMG" = "apk" ] && {
cd /etc/apk
$SUDO cp repositories repositories.bak
$SUDO sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
echo "Change apk source to 'mirrors.aliyun.com'"
exit 0
}

