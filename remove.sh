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
DOTFILE_HOME=.; for LIB in $DOTFILE_HOME/lib/??-*.sh; do . "$LIB"; done

#has bash || { install_pkg bash; }

# Install tools
for TOOL in $TOOLS
do
    sbin/tool-remove $INTERACTIVE $TOOL || {
        echo 'Batch remove stopped.'
        exit 1
    }
done
