#!/bin/bash

function doc() {
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

function print_help() {
    local cmd=${1:-$MYEXAMPLE_CMD}

    doc $MYEXAMPLE_HOME/bin/$cmd.sh u && echo
    doc $MYEXAMPLE_HOME/bin/$cmd.sh i && echo
    doc $MYEXAMPLE_HOME/bin/$cmd.sh f && echo
    echo "MyExample, version 0.0.1"

    return 0
}

function traverse() {
    local current_dir=$1
    local last_dir=
    while [ true ]
    do
        if [ -d "$current_dir/.myexample" ];then
            echo $current_dir
            exit
        fi
        last_dir=$current_dir
        current_dir=$(dirname $current_dir)
        if [ "$current_dir" = "$last_dir" ];then
            echo "fatal: Not a myexample repository (or any of the parent directories)">&2
            exit 128
        fi
    done
}
