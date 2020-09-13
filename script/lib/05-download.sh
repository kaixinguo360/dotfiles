# Usage: download REMOTE LOCAL [MODE]
download() {

    # Check Dependencies
    need curl

    # Get arguments
    local REMOTE="$1"
    local LOCAL="$2"
    local MODE="${3:-644}"

    # Verify arguments
    [ -z "$REMOTE" -o -z "$LOCAL" ] && return 1
    local LOCAL=$(realpath -m "$LOCAL")

    # Download
    echo "Downloading '${LOCAL##*/}' from '$REMOTE' ... " \
        && $SUDO mkdir -p "$(dirname $LOCAL)" \
        && $SUDO curl -f#SL "$REMOTE" -o "$LOCAL" \
        && $SUDO chmod $MODE "$LOCAL" \
        && echo "Saved to $LOCAL" && return 0 \
        || echo "Download '${LOCAL##*/}' failed." >&2 && return 1

}

