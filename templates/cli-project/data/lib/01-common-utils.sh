# Common Utils #

# Usage: traverse TARGET_DIR
function traverse() {
    local current_dir=$1
    local last_dir=
    while [ true ]
    do
        if [ -d "$current_dir/.myexample" ];then
            echo $current_dir
            exit
        fi
        last_dir=$current_dir
        current_dir=$(dirname $current_dir)
        if [ "$current_dir" = "$last_dir" ];then
            echo "fatal: Not a myexample repository (or any of the parent directories)">&2
            exit 128
        fi
    done
}
