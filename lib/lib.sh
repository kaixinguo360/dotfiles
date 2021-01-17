# Load libs
DOTFILE_HOME=..
for LIB in $DOTFILE_HOME/lib/??-*.sh;
do
    . "$LIB"
done

