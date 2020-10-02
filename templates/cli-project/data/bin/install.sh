#!/bin/bash
#i:Install MyExample to bin directory
#u:Usage: myexample install

# Set Static Variables
LOCATION=$(realpath ${PREFIX:-/usr/local}/bin)

# Start Install
rm -f $LOCATION/myexample \
    && ln -s $MYEXAMPLE_HOME/myexample $LOCATION/myexample \
    || exit

# Install Success
cat << HERE
MyExample has been installed to $LOCATION
See 'myexample help' to read help info.
HERE

