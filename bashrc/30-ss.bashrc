ss() {
    HOST="$1"; shift
    if [ -z "$*" ];then
        while true
        do
            ssh "$HOST" -t 'screen -d s;screen -r s||screen -S s'
            [ "$?" = '0' ] && break || sleep 2
        done
    else
        ssh "$HOST" -t "bash -ic '($@)'"
    fi
}
