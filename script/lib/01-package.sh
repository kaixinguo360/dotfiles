# Get Packages List
function pkg_list() {
    LIST_PATH="$ROOT_PATH/../data/pkg/$1"
    [ ! -f $LIST_PATH ] && return 1
    cat "$LIST_PATH"|sed 's/#.*$//'|sed -n '/^[^@].*$/p; /^@!.*:.*$/p; /^@'$PMG':.*$/p'|sed '/^@!'$PMG':.*$/d'|sed 's/@[^:]*://'
}

# Install Packages
function install_pkg() {
    is_installed $@ && { echo "Packages '$@' installed"; return 0; }
    echo Install Packages: $@
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && {
        [ -z "$IS_UPDATED" ] && { $SUDO apt update -q; export IS_UPDATED='y'; }
        DEBIAN_FRONTEND=noninteractive $SUDO apt install \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" \
            -yq $@
    }
    [ "$PMG" = "apk" ] && {
        $SUDO apk add --no-cache $@
    }
}

function install_list() {
    LIST=$(pkg_list $1) || { echo "No such list '$1'"; return 1; }
    is_installed $LIST && { echo "List '$1' installed"; return 0; }
    install_pkg $LIST
}

function install_script() {
    CMD_PATH="$ROOT_PATH/install/install_$1"; shift
    [ -f "$CMD_PATH" ] || { echo "No such script '$1'"; return 1; }
    $CMD_PATH $@
}

# Install Tools
function install_tool() {
    [ "$1" = "-i" ] && { INTERACTIVE='y'; shift; } || { INTERACTIVE=''; }
    TOOL="$1"; shift
    [ -z "$TOOL" ] && return 0
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT='y'
        [ "${TOOL##*.}" = "$TOOL" ] && { install_pkg $TOOL; return; }
        [ "${TOOL##*.}" = "list" ] && { install_list $TOOL; return; }
        [ "${TOOL##*.}" = "sh" ] && { install_script $TOOL $@; return; }
    [ -z "$INTERACTIVE" ] && unset IN_SCRIPT
}

# Ensure specified tools has been installed
function need() {
    for TOOL in "$@"
    do
        install_tool $TOOL || { echo "Dependent tool '$TOOL' installation failed"; exit 1; }
    done
}

# Start Service
function start_service() {
    only_support apt
    echo "Starting $1"
    $SUDO service $1 stop >/dev/null 2>&1
    $SUDO service $1 start >/dev/null
}

