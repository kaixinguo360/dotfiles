_completion_loader scp
complete -o nospace -F _scp v
v() {
    if [ ${1%%:*} = $1 ];then
        vim $@
    else
        FILE=remote.tmp.${1##*/}
        if [ ! -f "$FILE" ];then
            scp $1 $FILE
        fi
        if [[ $? = 0 ]];then
            vim $FILE
            scp $FILE $1
            if [[ $? = 0 ]];then
                rm $FILE
            else
                echo "Upload Fail!"
            fi
        else
            echo "Download Fail!"
        fi
    fi
}
