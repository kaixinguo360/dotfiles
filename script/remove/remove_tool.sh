#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "$0 [-i] [TOOL] [OPTION]..."
    echo -e "Remove tool"
    exit 0
fi

remove_tool $@ || {
    echo "An error occured while removing '$@'."
    exit 1
}

