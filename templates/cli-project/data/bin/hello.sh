#!/bin/bash
#i:A example command.
#u:Usage: myexample hello

echo "Hello,world!"

set_log_level 4
debug "MYEXAMPLE_HOME=$MYEXAMPLE_HOME"
debug "MYEXAMPLE_CMD=$MYEXAMPLE_CMD"

log "\033[32mTest text\033[0m"
error "Test text"
warn "Test text"
debug "Test text"
