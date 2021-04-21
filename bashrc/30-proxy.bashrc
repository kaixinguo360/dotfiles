# Set Proxy
setproxy() {
    [ "$1" = "-h" -o "$1" = "--help" ] && { type setproxy; return; }
    [ "$1" = "-" -o "$1" = "--" ] && { clearproxy; return; }
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
    (command -v git>/dev/null 2>&1) && {
        git config --global http.proxy "$PROXY" 
        git config --global https.proxy "$PROXY"
    }
    (command -v apt>/dev/null 2>&1) && {
        sudo rm -f /etc/apt/apt.conf.d/99-setproxy.auto-generated.conf
        sudo sh -c "cat > /etc/apt/apt.conf.d/99-setproxy.auto-generated.conf << HERE
Acquire::http::Proxy \"$PROXY\";
Acquire::https::Proxy \"$PROXY\";
Acquire::ftp::Proxy \"$PROXY\";
Acquire::socks::Proxy \"$PROXY\";
HERE"
    }
    #echo "Set proxy of HTTP/HTTPS/FTP/DEFAULT/GIT to '$PROXY'" >&2
    proxystatus
}
alias proxy=setproxy

# Clear Proxy
clearproxy() {
    [ "$1" = "-h" -o "$1" = "--help" ] && { type clearproxy; return; }
    unset PROXY
    unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY default_proxy DEFAULT_PROXY
    (command -v git>/dev/null 2>&1) && \
        git config --global --unset http.proxy && \
        git config --global --unset https.proxy
    (command -v apt>/dev/null 2>&1) && \
        sudo rm -f /etc/apt/apt.conf.d/99-setproxy.auto-generated.conf
    #echo "Clear proxy of HTTP/HTTPS/FTP/DEFAULT/GIT" >&2
    proxystatus
}
alias noproxy=clearproxy

# Proxy Status
proxystatus() {
    echo \# ENV
    echo PROXY=$PROXY
    echo http_proxy=$http_proxy
    echo HTTP_PROXY=$HTTP_PROXY
    echo https_proxy=$https_proxy
    echo HTTPS_PROXY=$HTTPS_PROXY
    echo ftp_proxy=$ftp_proxy
    echo FTP_PROXY=$FTP_PROXY
    echo default_proxy=$default_proxy
    echo DEFAULT_PROXY=$DEFAULT_PROXY
    (command -v git>/dev/null 2>&1) && {
        echo \# GIT
        echo git config --global http.proxy \"`git config --global http.proxy`\" && \
        echo git config --global https.proxy \"`git config --global https.proxy`\"
    }
    (command -v apt>/dev/null 2>&1) && {
        echo \# APT
        [ -f "/etc/apt/apt.conf.d/99-setproxy.auto-generated.conf" ] && {
            cat /etc/apt/apt.conf.d/99-setproxy.auto-generated.conf
        } || {
            echo "no proxy config"
        }
    }
}

# Start SSR
ssr() {
    if [ "$SSR" != "" ];then
        setproxy
        $SSR $@ &
        trap "ssrt" EXIT
    else
        echo "SSR is not installed!"
    fi
}

# Stop SSR
ssrt() {
    if [ "$SSR" != "" ];then
        noproxy
        kall $(ps -eo pid,cmd|grep -v grep|grep "$SSR"|awk '{print $1}')
        trap - EXIT
    else
        echo "SSR is not installed!"
    fi
}

# Test SSR
ssrtest() {
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

