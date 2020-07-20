# Usage: build_local_docker_image FROM_IMAGE ENTRYPOINT_ALIAS
build_local_docker_image() {
    
    [ -z "$1" ] && return 0
    local FROM_IMAGE="$1"
    local TARGET_IMAGE="my$1"

    [ -z "$2" ] && echo "Please input ENTRYPOINT_ALIAS of '$TARGET_IMAGE'" && return 1
    local ENTRYPOINT_ALIAS="$2"

    ######################
    # Build Docker Image #
    ######################

    # Jump to root directory
    cd $(dirname $(realpath $0))/../..

    # Build Command
    local CMD="docker build . -f- -t "$TARGET_IMAGE" --no-cache"
    #echo "$CMD < DOCKERFILE"

    # Build Dockerfile
    local DOCKERFILE=`cat << Dockerfile
FROM $FROM_IMAGE

WORKDIR /root

COPY / /root/.dotfiles

RUN .dotfiles/script/install.sh

ENTRYPOINT [ "bash", "-ic" ]

CMD [ "bash" ]
Dockerfile`
    #echo -e "-----BEGIN DOCKERFILE-----\n$DOCKERFILE\n-----END DOCKERFILE-----"

    # Build tagrget docker image
    echo -n "Building image '$TARGET_IMAGE'... " \
        && echo "$DOCKERFILE" | $CMD \
            > /tmp/build_local_docker_image.log \
        && rm /tmp/build_local_docker_image.log \
        && echo done.

    # Clean docker images
    docker image prune -f > /dev/null

    ###########################
    # Generate .bashrc Config #
    ###########################

    # Set arguments
    local BASHRCD_DIR="$HOME/.local/bashrc.d"
    local BASHRCD_FILE="99-dc-${FROM_IMAGE%%:*}.auto-generated.bashrc"
    local BASHRC_CONFIG=`cat << HERE
function $ENTRYPOINT_ALIAS() {
    if [ -n "\\$*" ]; then
        dc-run $TARGET_IMAGE "\\$*"
    else
        dc-run $TARGET_IMAGE
    fi
}
complete -F _command $ENTRYPOINT_ALIAS
HERE`

    # Create $HOME/dc/home directory
    mkdir -p "$BASHRCD_DIR"

    # Write to file
    #echo "cat > $BASHRCD_DIR/$BASHRCD_FILE < BASHRC_CONFIG"
    #echo -e "-----BEGIN BASHRC CONFIG-----\n$BASHRC_CONFIG\n-----END BASHRC CONFIG-----"
    echo -n "Creating entrypoint '$ENTRYPOINT_ALIAS'... " \
        && echo "$BASHRC_CONFIG" > "$BASHRCD_DIR/$BASHRCD_FILE" \
        && echo done.

}

# Usage: delete_local_docker_image FROM_IMAGE
delete_local_docker_image() {

    # Set arguments
    local FROM_IMAGE="$1"
    local BASHRCD_DIR="$HOME/.bin/local"
    local BASHRCD_FILE="99-dc-${FROM_IMAGE%%:*}.auto-generated.bashrc"

    # Remove docker image
    echo -n "Removing docker 'my$FROM_IMAGE'... " \
        && docker image rm "my$FROM_IMAGE" -f > /dev/null \
        && docker image prune -f > /dev/null \
        && echo done.

    # Remove .bashrc Config

    echo -n "Removing bashrc '$BASHRCD_FILE'... " \
        && rm -f $BASHRCD_DIR/$BASHRCD_FILE \
        && echo done.
}
