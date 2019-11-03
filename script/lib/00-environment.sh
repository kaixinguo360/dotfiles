# Get Environment Variable
[[ -n "$PREFIX" ]] && TERMUX='y'
[[ -n "$TERMUX" && -f "$PREFIX/etc/apt/sources.list.d/pointless.list" ]] && POINTLESS='y'
[[ -z "$TERMUX" && $UID -ne 0 ]] && SUDO='sudo'

# Get Package Manager
PKG="unkown"
[ -n "$(command -v apk)" ] && PKG="apk"
[ -n "$(command -v apt)" ] && PKG="apt"
[ -n "$TERMUX" ] && PKG="termux"

