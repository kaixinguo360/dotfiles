# Has Command
function has() {
    for CMD in $@
    do
        [ -z "$(command -v $CMD)" ] && return 1
    done
    echo yes
}

# Is Package Installed
function is_installed() {
    for CMD in $@
    do
        [ "$PMG" = "apt" -o "$PMG" = "termux" ] && [ -z "$(dpkg -s $CMD 2>/dev/null)" ] && return 1
        [ "$PMG" = "apk" ] && [ -z "$(apk info 2>/dev/null|grep -E '^$CMD$')" ] && return 1
    done
    echo yes
}

# Ensure specified tools has been installed
function need() {
    install_tool $@
}

# Get Packages List
function pkg_list() {
    if [ -n "$1" ];then
        LIST="$1"
    else
        LIST="default.list"
    fi
    LIST_PATH="$ROOT_PATH/../data/pkg/$LIST"
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

# Install Tools
function install_tool() {
    PKGS=''
    for TOOL in $@
    do
        LIST=$(pkg_list $TOOL)
        [ $? -eq 0 ] && { [ -z "$(is_installed $LIST)" ] && install_pkg $LIST; continue; }
        CMD_PATH="$ROOT_PATH/install/install_$TOOL"
        [ -f "$CMD_PATH" ] && { [ -z "$(has $TOOL)" ] && $CMD_PATH; continue; }
        [ -z "$(is_installed $TOOL)" ] && { PKGS="$PKGS $TOOL"; continue; }
    done
    [ -n "$PKGS" ] && install_pkg $PKGS
}

