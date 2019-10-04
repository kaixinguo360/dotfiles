#!/bin/bash
cd $(dirname $(realpath $0))

./remove_config.sh

CUSTOM="../data/remove.sh"
if [ -f "$CUSTOM" ];then
    echo "Running custom script $CUSTOM"
    [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
    $CUSTOM
fi
