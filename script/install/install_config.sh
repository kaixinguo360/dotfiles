#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

cd $ROOT_PATH/../data/config
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install config files"
    exit 0
fi

# Install
for dir in ${configs[@]};
do
    echo "Installing config files of '$dir'"
    CUSTOM="$dir/install.sh"
    if [ -f "$CUSTOM" ];then
        echo "Running custom script $CUSTOM"
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        echo "No custom script found, use default script."
        stow $dir -t $HOME
    fi
    [ "$?" != "0" ] && { echo "an error occured while installing config files of '$dir', installation stopped."; exit 1; }
    echo "Config files of '$dir' is ready"
done

