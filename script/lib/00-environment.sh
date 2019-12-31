# Get Environment Variable
[[ -n "$PREFIX" ]] && IS_TERMUX='y'
[[ -n "$IS_TERMUX" && ! -f "$PREFIX/etc/apt/sources.list.d/pointless.list" ]] && NEED_POINTLESS='y'
[[ -z "$IS_TERMUX" && $UID -ne 0 ]] && { SUDO='sudo'; sudo='sudo'; }
[[ -z "$IS_TERMUX" && -n "$(cat /proc/1/cgroup|grep docker)" ]] && IS_DOCKER='y'

# Get Package Manager
PMG="unkown"
[ -n "$(command -v apk)" ] && PMG="apk"
[ -n "$(command -v apt)" ] && PMG="apt"
[ -n "$IS_TERMUX" ] && PMG="termux"

# Default Arguments
[ -z "$DEFAULT_PASSWORD" ] && DEFAULT_PASSWORD=1234567
[ -z "$DEFAULT_HOST_NAME" ] && DEFAULT_HOST_NAME=$HOSTNAME

# Has Command
function has() {
    for CMD in $@
    do
        [ -z "$(command -v $CMD)" ] && return 1
    done
    return 0
}
function not_has() { if has $@; then return 1; else return 0; fi; }

# Is Package Installed
function is_installed() {
    for CMD in $@
    do
        [ "$PMG" = "apt" -o "$PMG" = "termux" ] && [ -z "$(dpkg -s $CMD 2>/dev/null)" ] && return 1
        [ "$PMG" = "apk" ] && [ -z "$(apk info 2>/dev/null|sed -n '/^'$CMD'$/p')" ] && return 1
    done
    return 0
}
function not_installed() { if is_installed $@; then return 1; else return 0; fi; }

# Only support specified package manager
function only_support() {
    [ "$1" = "-f" ] && return 0
    for CMD in $@
    do
        [ "$PMG" = "$CMD" ] && return 0
    done
    echo "Unsupported package manager '$PMG'" >&2
    exit 1
}

# Not support docker
function not_support_docker() {
    [ -n "$IS_DOCKER" ] && [ "$1" != "-f" ] && { echo "Unsupported environment 'docker'" >&2; exit 1; }
}

