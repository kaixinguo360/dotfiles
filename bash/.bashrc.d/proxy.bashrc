alias proxy=setproxy

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
}
function noproxy() {
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
}
