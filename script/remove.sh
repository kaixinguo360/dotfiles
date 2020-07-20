#!/bin/sh
cd $(dirname $(realpath $0))

# Show help info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo "$0 [-i] TOOL..."
    echo "Remove tools"
    exit 0
fi

# Read command line arguments
[ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
[ -z "$*" ] && TOOLS="config.sh" || TOOLS="$@"

# Load libs
ROOT_PATH=.; for LIB in $ROOT_PATH/lib/??-*.sh; do . "$LIB"; done

#has bash || { install_pkg bash; }

# Install tools
for TOOL in $TOOLS
do
    bin/tool-remove $INTERACTIVE $TOOL || {
        echo 'Batch remove stopped.'
        exit 1
    }
done
