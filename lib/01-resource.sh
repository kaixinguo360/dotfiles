# Add default DOTFILE_PATH: ~/.dotdata
# You can change this default value by add your own config in ~/.dotconfig
if [ -z "$DOTFILE_PATH" ]; then
    if [ -d "$HOME/.dotdata" ];then
        DOTFILE_PATH="$(realpath $HOME/.dotdata):$DOTFILE_HOME"
    else
        DOTFILE_PATH="$DOTFILE_HOME"
    fi
fi

# Load custom config
DOTFILE_CONFIG=${DOTFILE_CONFIG:-$HOME/.dotconfig}
if [ -f "$DOTFILE_CONFIG" ];then
    . "$DOTFILE_CONFIG"
fi

# Export global enviroment variable
export DOTFILE_HOME
export DOTFILE_PATH
export DOTFILE_CONFIG

# Usage: find_resource [-n|--name] [-a|--all] [-r|--reverse] [-o|--original] REGEX
find_resource() {

    # args
    for arg in "$@"
    do
        case $arg in
            -n|--name) local FLAG_NAME=yes; shift;;
            -a|--all) local FLAG_ALL=yes; shift;;
            -r|--reverse) local FLAG_REVERSE=yes; shift;;
            -o|--original) local FLAG_ORIGINAL=yes; shift;;
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
    local REGEX="$1"
    echo "${DOTFILE_PATH:-${DOTFILE_HOME}}" \
        | sed 's/:/\n/g' \
        | xargs -i find -L \
            {} \
            -maxdepth 2 \
            -mindepth 2 \
            -path "*/$REGEX" \
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
            [ -n "$FLAG_ORIGINAL" ] && cat && return
            sed 's#\(.*\)/\([^/]*\)#\2 \1/\2#' \
              | sort -k 1 \
              | sed 's#^[^/]* ##g'
          } \
        | {
            # Reverse
            [ -z "$FLAG_REVERSE" ] && cat && return
            tac
          } \
        | xargs -i $([ -n "$FLAG_NAME" ] && echo "basename" || echo "realpath") {}
}

