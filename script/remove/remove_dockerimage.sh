#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo "Remove local docker images"
    exit 0
fi

# Check Dependencies
not_support_docker $1
has docker || install_tool docker.sh

# Default images
[ -z "$*" ] && set \
    ubuntu:16.04 ub \
    alpine:3 ap \

# Build images
while [ -n "$*" ]
do
    remove_local_docker_image $1 $2 || exit
    #echo "Entrypoint '$ENTRYPOINT_ALIAS' has added to your bashrc"
    shift 2
done

echo "Use 'reloadbashrc' to reload bash config."
