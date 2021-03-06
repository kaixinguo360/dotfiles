#!/bin/sh

# Show help info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo "$0 [-i] TOOL..."
    echo "Install tools"
    exit 0
fi

# Load libs
DOTFILE_HOME="$(dirname $(realpath $0))"
for LIB in $DOTFILE_HOME/lib/??-*.sh
do
    . "$LIB"
done

# Change Work Directory
cd "$DOTFILE_HOME"

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
    sbin/tool-install $INTERACTIVE $TOOL || {
        echo 'Batch install stopped.'
        exit 1
    }
done
