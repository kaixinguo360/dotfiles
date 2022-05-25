################
# Install-tool #
################

# Install Packages
install_pkg() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    set "$(pmg_filter $*)"
    [ -z "$FORCE" ] && {
        is_installed $@ && { echo "Packages '$@' installed"; return 0; }
    }
    echo "Install Packages: $@"
    export LANG=C
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && {
        [ "$PMG" = "termux" ] && install_pointless
        [ -z "$IS_UPDATED" ] && { 
            echo -n " - updating... " \
                && $SUDO apt-get update -q \
                    2>&1 | spinner \
                    > $TMP_PATH/install_pkg.log \
                && rm $TMP_PATH/install_pkg.log \
                && export IS_UPDATED='y' \
                && echo "done."
        }
        echo -n " - installing... "
        DEBIAN_FRONTEND=noninteractive \
        _exec install_pkg \
            $SUDO apt-get install \
                -o Dpkg::Options::="--force-confdef" \
                -o Dpkg::Options::="--force-confold" \
                -o Dpkg::Use-Pty=0 \
                --no-install-recommends \
                -y -q $@
        return
    }
    [ "$PMG" = "yum" ] && {
        install_epel
        echo -n " - installing... "
        _exec install_pkg \
            $SUDO yum install -y $@
        return
    }
    [ "$PMG" = "apk" ] && {
        echo -n " - installing... "
        _exec install_pkg \
            $SUDO apk add --no-cache $@
        return
    }
}

install_list() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    has_list $1 || { echo "No such list '$1'" >&2; return 1; }
    PKGS=$(list_pkgs $1)
    [ -z "$FORCE" ] && {
        is_installed $PKGS && { echo "List '$1' installed"; return 0; }
    }
    (cd;list_pre $1|$SUDO sh)||return 1
    install_pkg $FORCE $PKGS||return 1
    (cd;list_post $1|$SUDO sh)||return 1
}

install_script() {
    CMD_PATH="$(find_resource "script/install_$1")"
    [ -f "$CMD_PATH" ] || { echo "No such script '$1'" >&2; return 1; }
    shift
    $CMD_PATH $@
}

# Install Tools
install_tool() {
    local INTERACTIVE BACKUP
    BACKUP=$IN_SCRIPT
    [ "$1" = "-i" ] && { INTERACTIVE='y'; shift; } || { INTERACTIVE=''; }
    TOOL="$1"; shift
    [ -z "$TOOL" ] && return 0
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT='y'
        if [ "${TOOL##*.}" = "list" ];then
            install_list $@ $TOOL; RET=$?;
        elif [ "${TOOL##*.}" = "sh" ];then
            install_script $TOOL $@; RET=$?;
        else
            install_pkg $@ $TOOL; RET=$?;
        fi
    [ -z "$INTERACTIVE" ] && export IN_SCRIPT=$BACKUP
    return $RET
}

###############
# Remove-tool #
###############

# Remove Packages
remove_pkg() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    set "$(pmg_filter $*)"
    [ -z "$FORCE" ] && {
        not_installed $@ && { echo "Packages '$@' not installed"; return 0; }
    }
    echo "Remove Packages: $@"
    [ "$PMG" = "apt" -o "$PMG" = "termux" ] && {
        echo -n " - removing... "
        DEBIAN_FRONTEND=noninteractive \
        _exec remove_pkg \
            $SUDO apt-get purge \
                -o Dpkg::Options::="--force-confdef" \
                -o Dpkg::Options::="--force-confold" \
                -o Dpkg::Use-Pty=0 \
                --auto-remove \
                -y -q $@
        return
    }
    [ "$PMG" = "yum" ] && {
        echo -n " - removing... "
        _exec remove_pkg \
            $SUDO yum remove -y $@
        return
    }
    [ "$PMG" = "apk" ] && {
        echo -n " - removing... "
        _exec remove_pkg \
            $SUDO apk del --no-cache $@
        return
    }
    if [ -z "$result" ]; then
        rm $TMP_PATH/remove_pkg.log
        echo "done."
        return 0
    else
        echo "failed"
        echo " + tail $TMP_PATH/remove_pkg.log"
        echo ' | -----'
        tail $TMP_PATH/remove_pkg.log \
            | sed 's/^/ | /g'
        echo ' +'
        return 1
    fi
}

remove_list() {
    [ "$1" = "-f" ] && { FORCE='-f'; shift; } || FORCE=''
    [ -z "$1" ] && return 0
    has_list $1 || { echo "No such list '$1'" >&2; return 1; }
    PKGS=$(list_pkgs $1)
    [ -z "$FORCE" ] && {
        not_installed $PKGS && { echo "List '$1' not installed"; return 0; }
    }
    (cd;list_pre $1|$SUDO sh)||return 1
    remove_pkg $FORCE $PKGS||return 1
    (cd;list_post $1|$SUDO sh)||return 1
}

remove_script() {
    CMD_PATH="$(find_resource "script/remove_$1")"
    [ -f "$CMD_PATH" ] || { echo "No such script '$1'" >&2; return 1; }
    shift
    $CMD_PATH $@
}

# Remove Tools
remove_tool() {
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

# Execute Command and Save Log
_exec() {
    logfile="$TMP_PATH/${1}.log"
    shift

    printf '%s\n-----\n' "$*" > "$logfile"

    exec 3>&1
    result=`(
        (
            $@ 2>&1 \
                || echo "failed" >&3
        ) | spinner >> "$logfile" \
    ) 3>&1`
    exec 3>&-

    if [ -z "$result" ]; then
        rm "$logfile"
        echo "done."
        return 0
    else
        echo "failed"
        echo ' +'
        tail "$logfile" \
            | sed 's/^/ | /g'
        echo ' +'
        echo "For more information, see the file $logfile"
        return 1
    fi
}

# Ensure specified tools has been installed
need() {
    for TOOL in "$@"
    do
        [ "${TOOL##*.}" = "$TOOL" ] \
            && has $TOOL \
            && continue;
        install_tool $TOOL || { echo "Dependent tool '$TOOL' installation failed" >&2; exit 1; }
    done
}

# Output beautify tool
spinner() {
    printf '[-] ' >&2

    while read line
    do
        printf '%s\n' "$line"

        for i in `seq 0 ${length:-0}`; do
            printf '\b \b' >&2
        done
        length=${#line}

        case ${index:-0} in
            0) printf '\b\b\b[\\]' >&2;;
            1) printf '\b\b\b[|]' >&2;;
            2) printf '\b\b\b[/]' >&2;;
            3) printf '\b\b\b[-]' >&2;;
        esac
        index=$(( ( ${index:-0} + 1 ) % 4 ))

        printf ' %s' "$line" >&2
    done

    for i in `seq 0 ${length:-0}`; do
        printf '\b \b' >&2
    done

    printf '\b\b\b   \b\b\b' >&2
}

###########
# Sercice #
###########

# Start Service
# Usage: start_service SERVICE_NAME
start_service() {
    echo -n "Starting $1 service... "
    if has service; then
        $SUDO service $1 stop >/dev/null 2>&1
        _exec start_service \
            $SUDO service $1 start
        return
    elif has systemctl; then
        $SUDO systemctl stop "$1.service" >/dev/null 2>&1
        _exec start_service \
            $SUDO systemctl start "$1.service"
        return
    else
        echo "skipped"
        return 1
    fi
}

# Stop Service
# Usage: stop_service SERVICE_NAME
stop_service() {
    echo -n "Stopping $1 service... "
    if has service; then
        _exec stop_service \
            $SUDO service $1 stop
        return
    elif has systemctl; then
        _exec stop_service \
            $SUDO systemctl stop "$1.service"
        return
    else
        echo "skipped"
        return 1
    fi
}

# Retart Service
# Usage: restart_service SERVICE_NAME
restart_service() {
    echo -n "Restarting $1 service... "
    if has service; then
        _exec restart_service \
            $SUDO service $1 restart
        return
    elif has systemctl; then
        _exec restart_service \
            $SUDO systemctl restart "$1.service"
        return
    else
        echo "skipped"
        return 1
    fi
}

########
# Port #
########

# Expose port
# Usage: expose_port PORT
expose_port() {
    local PORT=$1
    echo -n "Exposing port '$PORT'... " \
        && _expose_port $PORT >/dev/null \
        && echo 'done.'
}
_expose_port() {
    has ufw && $SUDO ufw allow $1
}

# Close port
# Usage: close_port PORT
close_port() {
    local PORT=$1
    echo -n "Closing port '$PORT'... " \
        && _close_port $PORT >/dev/null \
        && echo 'done.'
}
_close_port() {
    has ufw && $SUDO ufw delete allow $1
}

####################
# Termux Pointless #
####################

# Install Termux Pointless Source
install_pointless() {
    [ -n "$NEED_POINTLESS" ] && {
        unset NEED_POINTLESS
        need wget bash 'apt -f'
        wget https://its-pointless.github.io/setup-pointless-repo.sh -O setup-pointless-repo.sh
        bash setup-pointless-repo.sh
        rm -f setup-pointless-repo.sh pointless.gpg
    }
}

###############
# CentOS EPEL #
###############

# Install CentOS EPEL Source
install_epel() {
    [ ! -f "/etc/yum.repos.d/epel.repo" ] && {
        echo -n " - installing epel repo... "
        {
            $SUDO yum install -y epel-release
            $SUDO sed -e 's|^metalink=|#metalink=|g' \
                -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
                -e 's|^#baseurl=https\?://download.example/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
                -i.bak \
                /etc/yum.repos.d/epel.repo
            $SUDO yum clean all
            $SUDO yum makecache
        } \
            2>&1 | spinner \
            > $TMP_PATH/install_epel.log \
        && rm $TMP_PATH/install_epel.log \
        && echo "done."
    }
}

