# Parse Environment Variable #

# Get $MYEXAMPLE_HOME
MYEXAMPLE_HOME=$(dirname $(realpath $0))

# Get $MYEXAMPLE_CMD
[ "$1" = "" -o "$1" = "--help" -o "$1" = "-h" ] \
    && MYEXAMPLE_CMD='help' \
    || MYEXAMPLE_CMD=$1
shift

# Check $MYEXAMPLE_CMD
[ ! -f "$MYEXAMPLE_HOME/bin/$MYEXAMPLE_CMD.sh" ] && {
    echo "myexample: '$MYEXAMPLE_CMD' is not a myexample command. See '${0##*/} --help'.">&2
    exit 1
}

