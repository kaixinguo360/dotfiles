# Set Proxy
function setproxy() {
    if [ "$1" = "" ];then
        PROXY=$DEFAULT_PROXY
    else
        if [ "$1" -gt 0 ] 2>/dev/null ;then
            PROXY="socks5://localhost:$1"
        else
            PROXY=$1
        fi
    fi
    export http_proxy=$PROXY
    export HTTP_PROXY=$PROXY
    export https_proxy=$PROXY
    export HTTPS_PROXY=$PROXY
    export ftp_proxy=$PROXY
    export FTP_PROXY=$PROXY
}

alias proxy=setproxy

# Unset Proxy
function noproxy() {
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY
}

# Start SSR
function ssr() {
    if [ "$SSR" != "" ];then
        setproxy
        $SSR $@ &
        trap "ssrt" EXIT
    else
        echo "SSR is not installed!"
    fi
}

# Stop SSR
function ssrt() {
    if [ "$SSR" != "" ];then
        noproxy
        ps -eo pgid,cmd|grep -v grep|grep $SSR|awk '{print $1}'|xargs -i pkill -g {}
        trap - EXIT
    else
        echo "SSR is not installed!"
    fi
}


