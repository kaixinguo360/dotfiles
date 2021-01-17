# Load libs
DOTFILE_HOME=$(dirname $(realpath $0))/..
for LIB in $DOTFILE_HOME/lib/??-*.sh;
do
    . "$LIB"
done

