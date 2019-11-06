#!/bin/bash
cd $(dirname $(realpath $0))

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "$0 [-i] [TOOL]..."
    echo -e "Install tools"
    exit 0
fi

TOOLS="$@"
[ -z "$TOOLS" ] && {
    install/install_tool.sh default.list
    install/install_tool.sh config.sh
} || {
    [ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
    for TOOL in "$@"
    do
        install/install_tool.sh $INTERACTIVE $TOOL
    done
}

