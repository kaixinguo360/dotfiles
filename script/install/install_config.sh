#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

cd $ROOT_PATH/../data/config
configs=$(ls)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install config files"
    exit 0
fi

# Install Config
install_config() {
    files=$(ls -A $1)
    for file in ${files[@]}
    do
        rm -f $HOME/$file
        ln -s $(realpath $dir/$file) $HOME
    done
    #stow $1 -t $HOME
}

# Install
for dir in ${configs[@]};
do
    echo -n "Installing config of '$dir'... "
    CUSTOM="$dir/install.sh"
    if [ -f "$CUSTOM" ];then
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        install_config $dir
    fi
    [ "$?" != "0" ] && { echo "An error occured while installing config files of '$dir', installation stopped."; exit 1; }
    echo 'done.'
done

exit 0

