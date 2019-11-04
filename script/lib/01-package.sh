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

# Ensure specified tools has been installed
function need() {
    install_tool $@
}

# Has Command
function only() {
    for CMD in $@
    do
        [ "$PMG" = "$CMD" ] && return 0
    done
    echo "Unsupported package manager '$PMG'" >&2
    exit 1
}

# Get Packages List
function pkg_list() {
    LIST_PATH="$ROOT_PATH/../data/pkg/$1"
    [ ! -f $LIST_PATH ] && return 1
    cat "$LIST_PATH"|sed 's/#.*$//'|sed -n '/^[^@].*$/p; /^@!.*:.*$/p; /^@'$PMG':.*$/p'|sed '/^@!'$PMG':.*$/d'|sed 's/@[^:]*://'
}

# Install Packages
function install_pkg() {
    CMD=''
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && \
        { [ -z "$IS_UPDATED" ] && { CMD="$SUDO apt update &&"; IS_UPDATED='y'; }; CMD="$CMD $SUDO apt install -y $@"; }
    [ "$PMG" = "apk" ] && CMD="$SUDO apk add --no-cache $@"
    echo Install Packages: $@
    echo $CMD
    bash -c "$CMD"
}

function err() {
    echo "an error occured, script stopped."
    exit 1
}

# Install Tools
function install_tool() {
    PKGS=''
    export IN_SCRIPT='y'
    for TOOL in $@
    do
        LIST=$(pkg_list $TOOL)
        [ $? -eq 0 ] && { not_installed $LIST && { install_pkg $LIST || err; }; continue; }
        CMD_PATH="$ROOT_PATH/install/install_$TOOL"
        [ -f "$CMD_PATH" ] && { not_has $TOOL && { $CMD_PATH || err; }; continue; }
        not_installed $TOOL && { PKGS="$PKGS $TOOL"; continue; }
    done
    [ -n "$PKGS" ] && { install_pkg $PKGS || err; }
    unset IN_SCRIPT
    return 0
}

# Start Service
function start_service() {
    only apt
    echo "Starting $1"
    $SUDO service $1 stop >/dev/null 2>&1
    $SUDO service $1 start >/dev/null
}

