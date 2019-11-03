#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

cd $ROOT_PATH/../data/config
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove config files"
    exit 0
fi


# Remove
for dir in ${configs[@]};
do
    echo "Removing config files of '$dir'"
    CUSTOM="$dir/remove.sh"
    if [ -f "$CUSTOM" ];then
        echo "Running custom script $CUSTOM"
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        echo "No custom script found, use default script."
        stow -D $dir -t $HOME
    fi
    [ "$?" != "0" ] && { echo "An error occured while removing config files of '$dir', Remove stopped."; exit 1; }
    echo "Config files of '$dir' is removed"
done

