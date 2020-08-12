#!/bin/bash

NAME=$1
DESC=$2
[ -n "$3" ] && USER=$3

[ -z "$NAME" -o -z "$DESC" ] && echo "Usage: $0 NAME \"DESC\" [USER]" && exit 1
[ -d "/opt/$NAME" ] && echo "[ERROR] /opt/$NAME exists!" && exit 1

cd $(dirname $0)

rm -rf /tmp/$NAME
cp -a ./data /tmp/$NAME
sudo mv /tmp/$NAME /opt
cd /opt/$NAME

sed -i "s/myexample/$NAME/g" ./systemd/*
sed -i "s/MyExample/$DESC/g" ./systemd/*
sed -i "s/www-data/$USER/g" ./systemd/*

mv ./systemd/myexample ./systemd/$NAME
mv ./systemd/myexample.service ./systemd/$NAME.service

echo "[INFO] Success!"
