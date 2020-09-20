# Usage: download REMOTE_FILE LOCAL_FILE [MODE]
# Example: download https://example.com/script.sh /bin/script.sh 755
download() {

    # Check Dependencies
    need curl

    # Get arguments
    local REMOTE_FILE="$1"
    local LOCAL_FILE="$2"
    local MODE=${3:-644}

    # Verify arguments
    [ -z "$REMOTE_FILE" -o -z "$LOCAL_FILE" ] && return 1
    local LOCAL_FILE=$(realpath -m "$LOCAL_FILE")

    # Download
    echo "Downloading '$REMOTE_FILE' to '${LOCAL_FILE}'... " \
        && $SUDO mkdir -p "$(dirname $LOCAL_FILE)" \
        && $SUDO curl -f#SL "$REMOTE_FILE" -o "$LOCAL_FILE" \
        && $SUDO chmod $MODE "$LOCAL_FILE" \
        && echo "Saved to $LOCAL_FILE" && return 0 \
        || echo "Download '${LOCAL_FILE##*/}' failed." >&2 && return 1

}

# Usage: download_and_run REMOTE_SCRIPT SCRIPT_NAME
# Example: download_and_run https://example.com/script.sh script.sh
download_and_run() {

    # Check Dependencies
    need curl

    # Get arguments
    local REMOTE_SCRIPT="$1"
    local SCRIPT_NAME="$2"

    # Verify arguments
    [ -z "$REMOTE_SCRIPT" ] && return 1
    [ -z "$SCRIPT_NAME" ] && echo "[ERROR] download_and_run: Please input \$2(SCRIPT_NAME)" >&2 && return 1
    local LOCAL_SCRIPT=$(realpath -m "$TMP_PATH/script/$SCRIPT_NAME")

    # Download
    echo "Downloading remote script '$SCRIPT_NAME' from '$REMOTE_SCRIPT'... " \
        && $SUDO mkdir -p "$(dirname $LOCAL_SCRIPT)" \
        && $SUDO curl -f#SL "$REMOTE_SCRIPT" -o "$LOCAL_SCRIPT" \
        || { echo "Download remote script '${SCRIPT_NAME}' failed." >&2; return 1; }

    # Run
    (cd; $SUDO bash "$LOCAL_SCRIPT")

    # Return
    local RES=$?
    if [ "$RES" = '0' ]; then
        echo "Run remote script '${SCRIPT_NAME}' finished."
        $SUDO rm -f "$LOCAL_SCRIPT"
        return 0
    else
        echo "Run remote script '${SCRIPT_NAME}' failed. (return: $RES)" >&2
        return 1
    fi

}

