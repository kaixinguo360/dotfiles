# Get Environment Variable
ROOT_PATH=$(dirname $(realpath $0))
[[ -n "$PREFIX" ]] && TERMUX='y'
[[ -z "$TERMUX" && $UID -ne 0 ]] && SUDO='sudo'

# Get Package Manager
PKG="unkown"
[ -n "$(command -v apt)" ] && PKG="apt"
[ -n "$(command -v apk)" ] && PKG="apk"

# Install Package
function install_pkg() {
    [ "$PKG" = "apt" ] && CMD="$SUDO apt update && $SUDO apt install -y $@"
    [ "$PKG" = "apk" ] && CMD="$SUDO apk add --no-cache $@"
    echo Install Packages: $@
    echo $CMD
    bash -c "$CMD"
}
function pkg_list() {
    PKG_PATH="$ROOT_PATH/../data/packages.list"
    cat "$PKG_PATH"|sed -n '/^@'$PKG':.*$/p; /^[^@].*$/p'|sed 's/@'$PKG'://'
}
