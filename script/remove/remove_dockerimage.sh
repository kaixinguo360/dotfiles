#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo "Usage 1: install_dockerimage.sh FROM_IMAGE"
    echo "Usage 2: install_dockerimage.sh (interactive install)"
    echo -e "Build local docker images"
    exit 0
fi

# Check Dependencies
not_support_docker $1
has docker || install_tool docker.sh

# Read command line arguments
if [ -z "$@" ]; then
    # Read Input
    read_input \
        DOCKER_IMAGE_FROM str '[1/1] FROM IAMGE' 'ubuntu:16.04'
else
    DOCKER_IMAGE_FROM=$1
fi

delete_local_docker_image $DOCKER_IMAGE_FROM
