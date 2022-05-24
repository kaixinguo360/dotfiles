# Get Environment Variable
[ -n "$PREFIX" ] && IS_TERMUX='y'
[ -n "$IS_TERMUX" ] && [ ! -f "$PREFIX/etc/apt/sources.list.d/pointless.list" ] && NEED_POINTLESS='y'
[ -z "$IS_TERMUX" ] && [ ! "`id -u`" = "0" ] && { SUDO='sudo -E'; sudo='sudo -E'; }
[ -z "$IS_TERMUX" ] && [ -n "$(cat /proc/1/cgroup|grep docker)" ] && IS_DOCKER='y'

# Get Package Manager
PMG="unkown"
[ -n "$(command -v apk)" ] && PMG="apk"
[ -n "$(command -v apt-get)" ] && PMG="apt"
[ -n "$(command -v yum)" ] && PMG="yum"
[ -n "$IS_TERMUX" ] && PMG="termux"

# Get Tmp Dir
[ "$PMG" = "apk" ] && TMP_PATH="/tmp"
[ "$PMG" = "apt" ] && TMP_PATH="/tmp"
[ "$PMG" = "yum" ] && TMP_PATH="/tmp"
[ "$PMG" = "termux" ] && TMP_PATH=$(realpath "$HOME/../usr/tmp")

# Default Arguments
[ -z "$DEFAULT_PASSWORD" ] && DEFAULT_PASSWORD=1234567
[ -z "$DEFAULT_HOST_NAME" ] && DEFAULT_HOST_NAME=$HOSTNAME

# Common string filter
# Usage: set "$(pmg_filter $*)"
pmg_filter() {
    echo "$(
        echo "$*" \
        | sed "s/@$PMG:\([^ ]\+\)/\1/g" \
        | sed "s/@!$PMG:[^ :]\+//g" \
        | sed 's/@![^ :]\+:\([^ :]\+\)/\1/g' \
        | sed 's/@[^ :]\+:[^ :]\+//g' \
        | sed 's/ \+/ /g' \
        | sed 's/^ \+//g' \
        | sed 's/ \+$//g' \
    )"
}

# Has Command
has() {
    set "$(pmg_filter $*)"
    for CMD in $@
    do
        [ -z "$(command -v $CMD)" ] && return 1
    done
    return 0
}
not_has() { if has $@; then return 1; else return 0; fi; }

# Is All Input Package Installed
is_installed() {
    set "$(pmg_filter $*)"
    for CMD in $@
    do
        if [ "$PMG" = "apt" -o "$PMG" = "termux" ]; then
            [ -z "$(dpkg -s $CMD 2>/dev/null)" ] && return 1
        elif [ "$PMG" = "yum" ]; then
            yum list installed $CMD >/dev/null 2>&1 || return 1
        elif [ "$PMG" = "apk" ]; then
            [ -z "$(apk info 2>/dev/null|sed -n '/^'$CMD'$/p')" ] && return 1
        fi
    done
    return 0
}

# Is All Input Package Not Installed
not_installed() {
    set "$(pmg_filter $*)"
    for CMD in $@
    do
        if [ "$PMG" = "apt" -o "$PMG" = "termux" ]; then
            [ -n "$(dpkg -s $CMD 2>/dev/null)" ] && return 1
        elif [ "$PMG" = "yum" ]; then
            yum list installed $CMD >/dev/null 2>&1 && return 1
        elif [ "$PMG" = "apk" ]; then
            [ -n "$(apk info 2>/dev/null|sed -n '/^'$CMD'$/p')" ] && return 1
        fi
    done
    return 0
}

# Only support specified package manager
only_support() {
    [ "$1" = "-f" ] && return 0
    for CMD in $@
    do
        [ "$PMG" = "$CMD" ] && return 0
    done
    echo "Unsupported package manager '$PMG'" >&2
    exit 1
}

# Not support specified package manager
not_support() {
    [ "$1" = "-f" ] && return 0
    for CMD in $@
    do
        [ "$PMG" = "$CMD" ] \
            && echo "Unsupported package manager '$PMG'" >&2 \
            && exit 1
    done
    return 0
}

# Not support docker
not_support_docker() {
    [ -n "$IS_DOCKER" ] && [ "$1" != "-f" ] && { echo "Unsupported environment 'docker'" >&2; exit 1; }
}

