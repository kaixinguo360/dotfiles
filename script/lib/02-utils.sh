# Install Config
function install_config() {
    files=$(ls -A $1)
    for file in ${files[@]}
    do
        rm -f $HOME/$file
        ln -s $(realpath $dir/$file) $HOME
    done
    #stow $1 -t $HOME
}

# Remove Config
function remove_config() {
    files=$(ls -A $1)
    for file in ${files[@]}
    do
        rm -f $HOME/$file
    done
    #stow -D $1 -t $HOME
}

