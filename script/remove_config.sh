#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

configs=$(find_resource --name 'config/*')

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove config files"
    exit 0
fi

# Remove Config
remove_config() {
    local root="$1"
    local files=$(ls -A "$root")
    for file in ${files[@]}
    do
        rm -f $HOME/$file
    done
    #stow -D $1 -t $HOME
}

# Remove
for config in ${configs[@]};
do
    echo -n "Removing config files of '$config'... "
    config_root=$(find_resource "config/$config")
    CUSTOM="$config_root/remove.sh"
    if [ -f "$CUSTOM" ];then
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        remove_config $config_root
    fi
    [ "$?" != "0" ] && { echo "An error occured while removing config files of '$config', remove stopped."; exit 1; }
    echo 'done.'
done

exit 0

