# Make Alias
[ -n "$(command -v make)" ] && {

mmake() {
    current=$(realpath $(pwd))
    while [ true ]
    do
        if [ -f "$current/Makefile" ];then
            (cd $current && make $@)
            return
        fi
        LAST=$current
        current=$(dirname $current)
        if [ "$current" = "$LAST" ];then
            echo "fatal: Not a Makefile project (or any of the parent directories)">&2
            return 128
        fi
    done
}

}
