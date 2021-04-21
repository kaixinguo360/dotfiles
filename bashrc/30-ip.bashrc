CURL_TIMROUT=3
CURL_CMD="curl -s --connect-timeout $CURL_TIMROUT"

ip_check() {
    read IP
    if [ -z "$IP" ];then
        [ -n "$1" ] && echo "$1" >&2
        return 1
    else
        echo $IP
    fi
}

alias getip1="$CURL_CMD ifconfig.me|sed 's/$/\n/g'|ip_check 'Time out (ifconfig.me)'"
alias getip2="$CURL_CMD ip-api.com/line?fields=query|ip_check 'Time out (ip-api.com)'"

alias getip="(getip1||getip2)|ip_check 'Get ip failed'"

unset CURL_CMD CURL_TIMEOUT
