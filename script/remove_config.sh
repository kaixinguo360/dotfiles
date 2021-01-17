#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

cd $DOTFILE_HOME/config
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove config files"
    exit 0
fi

# Remove Config
remove_config() {
    files=$(ls -A $1)
    for file in ${files[@]}
    do
        rm -f $HOME/$file
    done
    #stow -D $1 -t $HOME
}

# Remove
for dir in ${configs[@]};
do
    echo -n "Removing config files of '$dir'... "
    CUSTOM="$dir/remove.sh"
    if [ -f "$CUSTOM" ];then
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        remove_config $dir
    fi
    [ "$?" != "0" ] && { echo "An error occured while removing config files of '$dir', remove stopped."; exit 1; }
    echo 'done.'
done

exit 0

