#!/bin/sh
cd $(dirname $(realpath $0))

# Load libs
for LIB in ./lib/??-*.sh; do . "$LIB"; done

# Show help info
if [ "$1" = "-h" -o "$1" = "--help" ];then
    echo -e "$0 [-i] [TOOL]..."
    echo -e "Install tools"
    exit 0
fi

# Read command line arguments
[ "$1" = "-i" ] && { INTERACTIVE='-i'; shift; } || { INTERACTIVE=''; }
[ -z "$*" ] && TOOLS="default.list config.sh" || TOOLS="$@"

install/install_cnsrc.sh
has bash || { install_pkg bash; }

# Install tools
for TOOL in $TOOLS
do
    install/install_tool.sh $INTERACTIVE $TOOL
done
