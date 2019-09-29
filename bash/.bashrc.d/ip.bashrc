CURL_TIMROUT=1
CURL_CMD="curl -s --connect-timeout $CURL_TIMROUT"
alias getip1="$CURL_CMD ifconfig.me|sed 's/$/\n/g'"
alias getip2="$CURL_CMD ip-api.com/line?fields=query"

alias getip="(getip1||getip2)"

unset CURL_CMD CURL_TIMEOUT
