# Parse Flags #

# Print Help of $MYEXAMPLE_CMD
[ "$1" = "--help" -o "$1" = "-h" ] \
    && print_help && exit 0

# Set $LOG_LEVEL
LOG_LEVEL=1

