#!/bin/bash
#i:List available subcommands and some concept guides.
#u:Usage: myexample help <command>

CMD=$1

cd $MYEXAMPLE_HOME/bin
if [ "$CMD" = "" ];then # if

cat <<HERE
usage: myexample <command> [<args>] [--help] [-h]

These are common MyExample commands used in various situations:

HERE

for FILE in $(ls -1)
do
    echo -en '   '${FILE%%.*}'\n'
    doc $FILE i|awk '{print "         "$0}'
done

cat <<HERE

See 'myexample help <command>' to read about a specific subcommand.
HERE

else # else

[ ! -f "$CMD.sh" ] && {
    echo "myexample: '$CMD' is not a myexample command. See '${0##*/} --help'.">&2
    exit 1
}

print_help $CMD

fi #fi

