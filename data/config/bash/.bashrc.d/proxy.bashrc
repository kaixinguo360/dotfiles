# Set Proxy
function setproxy() {
    if [ "$1" = "" ];then
        PROXY=$PRESET_PROXY
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
    export default_proxy=$PROXY
    export DEFAULT_PROXY=$PROXY
    (git --version>/dev/null 2>&1) && \
            git config --global http.proxy "$PROXY" && \
            git config --global https.proxy "$PROXY"
}

alias proxy=setproxy

# Unset Proxy
function noproxy() {
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY default_proxy DEFAULT_PROXY
    (git --version>/dev/null 2>&1) && \
            git config --global --unset http.proxy && \
            git config --global --unset https.proxy
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
        kall $(ps -eo pid,cmd|grep -v grep|grep "$SSR"|awk '{print $1}')
        trap - EXIT
    else
        echo "SSR is not installed!"
    fi
}

# Test SSR
function ssrtest() {
    if [ "$SSR" != "" ];then
        setproxy
        ($SSR $@ &)
        sleep 1
        IP=$(getip)
        if [ "$IP" != "" ];then
            echo -e "\n  ## \033[32m测试成功\033[0m ##\n"
            echo 'IP: '$IP
            ssrt
            return 0
        else
            echo -e "\n  ## \033[31m测试失败\033[0m ##\n"
            echo 'Test Failed!'
            ssrt
            return 1
        fi
    else
        echo "SSR is not installed!"
        return 1
    fi
}

