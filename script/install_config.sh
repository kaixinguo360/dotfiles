#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

configs=$(find_resource config)

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install config files"
    exit 0
fi

# Install Config
install_config() {
    local root="$1"
    local files=$(ls -A "$root")
    for file in ${files[@]}
    do
        rm -f $HOME/$file
        ln -s $(realpath $root/$file) $HOME
    done
    #stow $1 -t $HOME
}

# Install
for config in ${configs[@]};
do
    echo -n "Installing config of '$config'... "
    config_root=$(find_resource --path config "$config")
    CUSTOM="$config_root/install.sh"
    if [ -f "$CUSTOM" ];then
        [ ! -x "$CUSTOM" ] && { echo "Permission denied, can't execute $CUSTOM"; exit 1; }
        $CUSTOM
    else
        install_config $config_root
    fi
    [ "$?" != "0" ] && { echo "An error occured while installing config files of '$config', installation stopped."; exit 1; }
    echo 'done.'
done

exit 0

