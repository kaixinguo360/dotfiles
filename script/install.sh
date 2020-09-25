#!/bin/sh

cd $(dirname $(realpath $0))

# Show help info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo "$0 [-i] TOOL..."
    echo "Install tools"
    exit 0
fi

# Load libs
ROOT_PATH=.; for LIB in $ROOT_PATH/lib/??-*.sh; do . "$LIB"; done

# Read command line arguments
[ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
[ -z "$*" ] && TOOLS="default.list config.sh" || TOOLS="$@"

# Use mirror 
#install/install_cnsrc.sh

# Install bash
has bash || { install_pkg bash; }

# Install tools
for TOOL in $TOOLS
do
    bin/tool-install $INTERACTIVE $TOOL || {
        echo 'Batch install stopped.'
        exit 1
    }
done
