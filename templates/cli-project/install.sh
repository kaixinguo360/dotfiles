#!/bin/bash

NAME=$1
[ -z "$NAME" ] \
    && echo "Usage: $0 ProjectName [/path/to/project]" \
    && exit 1
NAME_LOWERCASE=$(echo $NAME|tr '[A-Z]' '[a-z]')
NAME_UPPERCASE=$(echo $NAME|tr '[a-z]' '[A-Z]')

TARGET=$2
[ -z "$TARGET" ] \
    && TARGET=$(pwd)
TARGET=$(realpath $TARGET)
[ ! -d "$TARGET" ] \
    && echo "[ERROR] $TARGET not exist!" \
    && exit 1
[ -d "$TARGET/$NAME_LOWERCASE" ] \
    && echo "[ERROR] $TARGET/$NAME_LOWERCASE exists!" \
    && exit 1

cd $(dirname $0)

rm -rf /tmp/$NAME_LOWERCASE
cp -a ./data /tmp/$NAME_LOWERCASE
sudo mv /tmp/$NAME_LOWERCASE $TARGET
cd $TARGET/$NAME_LOWERCASE

sed -i "s/MyExample/$NAME/g" myexample ./*/*
sed -i "s/myexample/$NAME_LOWERCASE/g" myexample ./*/*
sed -i "s/MYEXAMPLE/$NAME_UPPERCASE/g" myexample ./*/*
mv ./myexample ./$NAME_LOWERCASE

echo "[INFO] Success!"
