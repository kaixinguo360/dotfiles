# Read Input
read_input() {
    [ -z "$read_input_run" ] && {
        echo "script: ${0##*/}"
        echo "----------------"
        echo " Read Arguments "
        echo "----------------"
        read_input_run=y
    }
    while [ -n "$1" ]
    do
        NAME="$1"; shift
        TYPE="$1"; shift
        INFO="$1"; shift
        DEFAULT="$1"; shift
        [ -z "$(eval echo \$$NAME)" ] && {
            [ -n "$IN_SCRIPT" ] && { [ -n "$DEFAULT" -a "$DEFAULT" != "-" ] \
                && { eval "$NAME=\"$DEFAULT\""; echo -n '(default) '; }\
                || { echo "$NAME not set" >&2; exit 1; };
            } || {
                echo ''
                eval read_$TYPE $NAME \"$INFO\" \"$DEFAULT\"
                export $NAME
            }
        } || {
            echo -n '(inherit) '
        }
        echo "$NAME=$(eval echo \"\$$NAME\")"
    done
    echo "----------------"
}


# Read Anything
read_bool() {
    echo -e "\033[32m$2\033[0m"
    [ -n "$3" -a "$3" != "-" ] && INFO="[Y/n] (default: $3):" || INFO="[Y/n]"
    while true :
    do read -r -p "$INFO " input
        case $input in
            [yY][eE][sS]|[yY])
                INPUT='y'
                break
                ;;

            [nN][oO]|[nN])
                INPUT='n'
                break
                ;;

            '')
                if [ -n "$3" -a "$3" != "-" ];then
                    INPUT="$3"
                    break
                else
                    echo "Invalid input..."
                fi
                ;;
    
            *)
                echo "Invalid input..."
                ;;
        esac
    done
    eval "$1=$INPUT"
}

read_str() {
    echo -e "\033[32m$2\033[0m"
    [ -n "$3" -a "$3" != "-" ] && INFO="Input (default: $3):" || INFO="Input:"
    while true :
    do read -r -p "$INFO " input
        case $input in
            '')
                if [ -n "$3" -a "$3" != "-" ];then
                    INPUT="$3"
                    break
                else
                    echo "Invalid input..."
                fi
                ;;
    
            *)
                INPUT="$input"
                break
                ;;
        esac
    done
    eval "$1=\"$INPUT\""
}

read_pass() {
    echo -e "\033[32m$2\033[0m"
    [ -n "$3" -a "$3" != "-" ] && INFO="Input (default: $3):" || INFO="Input:"
    while true :
    do
        read -s -p "$INFO " input_1
        [ -z "$input_1" ] && { INPUT="$3"; break;}
        echo ''
        read -s -p 'Input again: ' input_2
        if [ "$input_1" = "$input_2" ]; then
            INPUT="$input_1"
            break
        else
            echo -e "两次输入密码不一致!\n"
        fi
    done
    eval "$1=\"$INPUT\""
    echo ''
}

