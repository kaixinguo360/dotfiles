# Log Utils #

# Set default log level
LOG_LEVEL=${LOG_LEVEL:-3}

# Usage: set_log_level LOG_LEVEL
set_log_level() {
    LOG_LEVEL=${1:-1}
    debug "Set LOG_LEVEL=$LOG_LEVEL"
}

# Usage: LEVEL=n log "MESSAGE" [LEVEL=2] [FLAG=INFO]
log() {
    local msg="$1"
    local level=${2:-2};
    local flag=${3:-INFO}

    [ -n "$LEVEL" ] \
        && [ "$LEVEL" -ne "$level" ] \
        && level=$LEVEL \
        && flag="$flag:$LEVEL"

    [ "$LOG_LEVEL" -ge "$level" ] \
        && printf "[$flag] $msg\n";
}

# Usage: error "ERROR_MESSAGE" [LEVEL=1] [FLAG=ERROR]
error() {
    printf '\033[31m' >&2;
    log "$1" ${2:-1} ${3:-ERROR} >&2;
    printf '\033[0m' >&2;
}

# Usage: warn "WARN_MESSAGE" [LEVEL=3] [FLAG=WARN]
warn() {
    printf '\033[33m' >&2;
    log "$1" ${2:-3} ${3:-WARN} >&2;
    printf '\033[0m' >&2;
}

# Usage: debug "DEBUG_MESSAGE" [LEVEL=4] [FLAG=DEBUG]
debug() {
    log "$*" ${2:-4} "\033[34m${3:-DEBUG}\033[0m";
}

