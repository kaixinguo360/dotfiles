# Usage: find_resource [-p|--path] [-a|--all] [-r|--reverse] [-n|--no-sort] TYPE [REGEX]
find_resource() {

    # args
    for arg in "$@"
    do
        case $arg in
            -p|--path) local FLAG_PATH=yes; shift;;
            -a|--all) local FLAG_ALL=yes; shift;;
            -r|--reverse) local FLAG_REVERSE=yes; shift;;
            -n|--no-sort) local FLAG_NO_SORT=yes; shift;;
            *) break;;
        esac
    done

    # main
    if [ -z "$*" ]; then
        echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
            | sed 's/:/\n/g' \
            | {
                # Reverse
                [ -z "$FLAG_REVERSE" ] && cat && return
                tac
              }
        return
    fi
    local TYPE="$1"
    local REGEX="$2"
    echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
        | sed 's/:/\n/g' \
        | xargs -i find -L \
            {} \
            -maxdepth 2 \
            -mindepth 2 \
            -path "*/$TYPE/$([ -n "$REGEX" ] && echo "$REGEX" || echo "[^.]*")" \
            2>/dev/null \
        | {
            # Drop Repeated Resource
            [ -n "$FLAG_ALL" ] && cat && return
            local names=
            while read input
            do
                local name=${input##*/}
                [ -n "$(echo "$names"|grep "$name")" ] && continue
                local names="$names <$name>"
                echo "$input"
            done
          } \
        | {
            # Sort By Resource Name
            [ -n "$FLAG_NO_SORT" ] && cat && return
            sed 's#\(.*\)/\([^/]*\)#\2 \1/\2#' \
              | sort -k 1 \
              | sed 's#^[^/]* ##g'
          } \
        | {
            # Reverse
            [ -z "$FLAG_REVERSE" ] && cat && return
            tac
          } \
        | xargs -i $([ -n "$FLAG_PATH" ] && echo "realpath" || echo "basename") {}
}

