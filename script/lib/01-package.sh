# Install Packages
function install_pkg() {
    [ "$PKG" = "apt" ] && CMD="$SUDO apt update && $SUDO apt install -y $@"
    [ "$PKG" = "apk" ] && CMD="$SUDO apk add --no-cache $@"
    [ "$PKG" = "termux" ] && CMD="$SUDO apt update && $SUDO apt install -y $@"
    echo Install Packages: $@
    echo $CMD
    bash -c "$CMD"
}

# Get Packages List
function pkg_list() {
    if [ -n "$1" ];then
        LIST="$1"
    else
        LIST="default"
    fi
    PKG_PATH="$ROOT_PATH/../data/pkg/$LIST.list"
    [ ! -f $PKG_PATH ] && { echo "No such list: $LIST">&2; return 1; }
    cat "$PKG_PATH"|sed 's/#.*$//'|sed -n '/^[^@].*$/p; /^@!.*:.*$/p; /^@'$PKG':.*$/p'|sed '/^@!'$PKG':.*$/d'|sed 's/@[^:]*://'
}
