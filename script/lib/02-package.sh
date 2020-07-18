################
# Install-tool #
################

# Install Packages
function install_pkg() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    [ -z "$FORCE" ] && {
        is_installed $@ && { echo "Packages '$@' installed"; return 0; }
    }
    echo Install Packages: $@
    [ "$PMG" = "termux" ] && install_pointless
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && {
        [ -z "$IS_UPDATED" ] && { $SUDO apt update -q; export IS_UPDATED='y'; }
        DEBIAN_FRONTEND=noninteractive $SUDO apt install \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" \
            --no-install-recommends \
            -yq $@
        return
    }
    [ "$PMG" = "apk" ] && {
        $SUDO apk add --no-cache $@
        return
    }
}

function install_list() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    has_list $1 || { echo "No such list '$1'"; return 1; }
    PKGS=$(list_pkgs $1)
    [ -z "$FORCE" ] && {
        is_installed $PKGS && { echo "List '$1' installed"; return 0; }
    }
    (cd;list_pre $1|$SUDO sh)||return 1
    install_pkg $FORCE $PKGS||return 1
    (cd;list_post $1|$SUDO sh)||return 1
}

function install_script() {
    CMD_PATH="$ROOT_PATH/install/install_$1"; shift
    [ -f "$CMD_PATH" ] || { echo "No such script '$1'"; return 1; }
    $CMD_PATH $@
}

# Install Tools
function install_tool() {
    local INTERACTIVE BACKUP
    BACKUP=$IN_SCRIPT
    [ "$1" = "-i" ] && { INTERACTIVE='y'; shift; } || { INTERACTIVE=''; }
    TOOL="$1"; shift
    [ -z "$TOOL" ] && return 0
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT='y'
        if [ "${TOOL##*.}" = "$TOOL" ];then
            install_pkg $@ $TOOL; RET=$?;
        elif [ "${TOOL##*.}" = "list" ];then
            install_list $@ $TOOL; RET=$?;
        elif [ "${TOOL##*.}" = "sh" ];then
            install_script $TOOL $@; RET=$?;
        fi
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT=$BACKUP
    return $RET
}

###############
# Remove-tool #
###############

# Remove Packages
function remove_pkg() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    [ -z "$FORCE" ] && {
        not_installed $@ && { echo "Packages '$@' not installed"; return 0; }
    }
    echo Remove Packages: $@
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && {
        DEBIAN_FRONTEND=noninteractive $SUDO apt purge \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" \
            --auto-remove \
            -yq $@
        return
    }
    [ "$PMG" = "apk" ] && {
        $SUDO apk del --no-cache $@
        return
    }
}

function remove_list() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    has_list $1 || { echo "No such list '$1'"; return 1; }
    PKGS=$(list_pkgs $1)
    [ -z "$FORCE" ] && {
        not_installed $PKGS && { echo "List '$1' not installed"; return 0; }
    }
    (cd;list_pre $1|$SUDO sh)||return 1
    remove_pkg $FORCE $PKGS||return 1
    (cd;list_post $1|$SUDO sh)||return 1
}

function remove_script() {
    CMD_PATH="$ROOT_PATH/remove/remove_$1"; shift
    [ -f "$CMD_PATH" ] || { echo "No such script '$1'"; return 1; }
    $CMD_PATH $@
}

# Remove Tools
function remove_tool() {
    local INTERACTIVE BACKUP
    BACKUP=$IN_SCRIPT
    [ "$1" = "-i" ] && { INTERACTIVE='y'; shift; } || { INTERACTIVE=''; }
    TOOL="$1"; shift
    [ -z "$TOOL" ] && return 0
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT='y'
        if [ "${TOOL##*.}" = "$TOOL" ];then
            remove_pkg $@ $TOOL; RET=$?;
        elif [ "${TOOL##*.}" = "list" ];then
            remove_list $@ $TOOL; RET=$?;
        elif [ "${TOOL##*.}" = "sh" ];then
            remove_script $TOOL $@; RET=$?;
        fi
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT=$BACKUP
    return $RET
}

#########
# Other #
#########

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

# Install Pointless source
function install_pointless() {
    [[ -n "$NEED_POINTLESS" ]] && {
        unset NEED_POINTLESS
        need wget bash 'apt -f'
        wget https://its-pointless.github.io/setup-pointless-repo.sh -O setup-pointless-repo.sh
        bash setup-pointless-repo.sh
        rm -f setup-pointless-repo.sh pointless.gpg
    }
}

