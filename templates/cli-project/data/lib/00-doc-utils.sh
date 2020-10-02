# Document Utils #

# Usage: doc PATH_TO_CMD
doc() {
    local file=$1
    local flag=$2
    local num=0

    while read LINE
    do
        if [ "${LINE%%:*}" = "#$flag" ];then
            echo "${LINE#*:}"
            num=$[$num+1]
        fi
        if [ "${LINE:0:1}" != "#" ];then
            break
        fi
    done < $file

    [ "$num" = 0 ] && return 1
    return 0
}

# Usage: print_help [CMD]
print_help() {
    local cmd=${1:-$MYEXAMPLE_CMD}

    doc $MYEXAMPLE_HOME/bin/$cmd.sh u && echo
    doc $MYEXAMPLE_HOME/bin/$cmd.sh i && echo
    doc $MYEXAMPLE_HOME/bin/$cmd.sh f && echo
    echo "MyExample, version 0.0.1"

    return 0
}

