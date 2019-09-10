ssc() {
    if [[ $@ = "" ]];then
        for((;;))
        do
            ssh kaixinguo -t 'screen -d s;screen -r s||screen -S s'
        if [ $? -eq 0 ];then
            break;
        else
            sleep 2;
        fi
        done
    else
        ssh kaixinguo -t "bash -ic '($@)'"
    fi
}
