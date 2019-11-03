# Load libs
ROOT_PATH=$(dirname $(realpath $0))/..
for LIB in $ROOT_PATH/lib/*.sh;
do
    . "$LIB"
done

