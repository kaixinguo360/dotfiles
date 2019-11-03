#!/bin/bash
cd $(dirname $(realpath $0))

install/install_package.sh
install/install_config.sh

CUSTOM="../data/install.sh"
if [ -f "$CUSTOM" ];then
    echo "Running custom script $CUSTOM"
    [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
    $CUSTOM
fi
