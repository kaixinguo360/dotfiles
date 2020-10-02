# Log Utils #

# Usage: log_error "ERROR_MESSAGE"
log_error() { [ "$LOG_LEVEL" -ge 0 ] && echo "[ERROR] $*" >&2; }

# Usage: log_info "INFO_MESSAGE"
log_info() { [ "$LOG_LEVEL" -ge 1 ] && echo "[INFO] $*" >&2; }

# Usage: log_debug "DEBUG_MESSAGE"
log_debug() { [ "$LOG_LEVEL" -ge 2 ] && echo "[DEBUG] $*" >&2; }

