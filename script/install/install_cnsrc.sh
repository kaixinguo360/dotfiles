#!/bin/sh
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo -e "Change China Source"
    exit 0
fi

# Check Dependencies
only_support $1 apt termux apk

# apt
[ "$PMG" = "apt" ] && {
cd /etc/apt
echo -n "Changing apt source to 'mirrors.aliyun.com'... " \
    && $SUDO cp sources.list sources.list.bak \
    && $SUDO sed -i 's@\(deb-*s*r*c*\) \+\(https*://[^ ]*\) \+\([^ ]*\) \+\([^ ]*\)\(.*\)@\1 http://mirrors.aliyun.com/ubuntu/ \3 \4\5@' sources.list \
    && echo done.
echo -n 'Updating apt... ' \
    && $SUDO apt-get update -q \
        > /tmp/update_apt.log \
    && rm /tmp/update_apt.log \
    && echo done.
exit 0
}

# termux
[ "$PMG" = "termux" ] && {
cd $PREFIX/etc/apt
echo -n "Change termux source to 'mirrors.tuna.tsinghua.edu.cn'... " \
    && cp sources.list sources.list.bak \
    && sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux stable main@' \
        $PREFIX/etc/apt/sources.list \
    && apt-get update -q \
exit 0
}

# apk
[ "$PMG" = "apk" ] && {
cd /etc/apk
echo -n "Change apk source to 'mirrors.aliyun.com'... " \
    && $SUDO cp repositories repositories.bak \
    && $SUDO sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && echo done.
exit 0
}

