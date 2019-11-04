# Get Environment Variable
[[ -n "$PREFIX" ]] && TERMUX='y'
[[ -n "$TERMUX" && -f "$PREFIX/etc/apt/sources.list.d/pointless.list" ]] && POINTLESS='y'
[[ -z "$TERMUX" && $UID -ne 0 ]] && SUDO='sudo'

# Get Package Manager
PMG="unkown"
[ -n "$(command -v apk)" ] && PMG="apk"
[ -n "$(command -v apt)" ] && PMG="apt"
[ -n "$TERMUX" ] && PMG="termux"

