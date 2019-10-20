ss() {
    HOST=$1
    shift
    if [[ $@ = "" ]];then
        for((;;))
        do
            ssh $HOST -t 'screen -d s;screen -r s||screen -S s'
        if [ $? -eq 0 ];then
            break;
        else
            sleep 2;
        fi
        done
    else
        ssh $HOST -t "bash -ic '($@)'"
    fi
}
