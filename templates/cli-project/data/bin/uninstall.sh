#!/bin/bash
#i:Uninstall MyExample from bin directory
#u:Usage: myexample uninstall

# Set Static Variables
LOCATION=$(realpath ${PREFIX:-/usr/local}/bin)

# Start Uninstall
rm -f $LOCATION/myexample \
    || exit

# Uninstall Success
cat << HERE
MyExample has been uninstalled from $LOCATION.
HERE

