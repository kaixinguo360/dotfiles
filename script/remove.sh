#!/bin/bash
cd $(dirname $(realpath $0))

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "$0 [-i] [TOOL]..."
    echo -e "Remove tools"
    exit 0
fi

TOOLS="$@"
[ -z "$TOOLS" ] && {
    remove/remove_tool.sh config.sh
} || {
    [ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
    for TOOL in "$@"
    do
        remove/remove_tool.sh $INTERACTIVE $TOOL
    done
}

# Post-remove script
CUSTOM="../data/remove.sh"
if [ -f "$CUSTOM" ];then
    echo "Running custom script $CUSTOM"
    [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
    $CUSTOM
fi

