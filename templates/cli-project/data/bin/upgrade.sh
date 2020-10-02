#!/bin/bash
#i:Upgrade MyExample to latest version
#u:Usage: myexample upgrade

cd $MYEXAMPLE_HOME \
    && git fetch --all \
    && git reset --hard origin/master \
    && git pull \
    && git clean -fd
