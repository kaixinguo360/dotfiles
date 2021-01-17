# Usage: find_resource TYPE NAME
find_resource() {
    local TYPE="$1"
    local NAME="$2"
    echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
        | sed 's/:/\n/g' \
        | xargs -i find {} \
            -maxdepth 2 \
            -mindepth 2 \
            -path "*/$TYPE/$NAME" \
            2>/dev/null \
        | head -n1 \
        | xargs -i realpath {}
}

# Usage: find_resources TYPE NAME
find_resources() {
    local TYPE="$1"
    local NAME="$2"
    echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
        | sed 's/:/\n/g' \
        | xargs -i find {} \
            -maxdepth 2 \
            -mindepth 2 \
            -path "*/$TYPE/$NAME" \
            2>/dev/null \
        | xargs -i realpath {}
}

# Usage: list_resource TYPE REGEX
list_resource() {
    local TYPE="$1"
    local REGEX="$2"
    echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
        | sed 's/:/\n/g' \
        | xargs -i find {} \
            -maxdepth 2 \
            -mindepth 2 \
            -path "*/$TYPE/$([ -n "$REGEX" ] && echo "$REGEX" || echo "[^.]*")" \
            2>/dev/null \
        | xargs -i basename {} \
        | sort \
        | uniq
}

