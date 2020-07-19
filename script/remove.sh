#!/bin/sh
cd $(dirname $(realpath $0))

# Load libs
for LIB in ./lib/??-*.sh; do . "$LIB"; done

# Show help info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo -e "$0 [-i] [TOOL]..."
    echo -e "Remove tools"
    exit 0
fi

# Read command line arguments
[ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
[ -z "$*" ] && TOOLS="config.sh" || TOOLS="$@"

#has bash || { install_pkg bash; }

# Install tools
for TOOL in $TOOLS
do
    remove/remove_tool.sh $INTERACTIVE $TOOL || {
        echo 'Batch remove stopped.'
        exit 1
    }
done
