#!/bin/bash
cd $(dirname $(realpath $0))

TOOLS=$@
[ -z "$@" ] && TOOLS='default.list config.sh'

install/install_tool.sh $TOOLS
