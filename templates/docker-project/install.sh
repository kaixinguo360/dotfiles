#!/bin/bash

TEMPLATE_NAME=$1
TEMPLATE_IMAGE=$2
TEMPLATE_IMAGE_PORT=${3:-80}
TEMPLATE_DATA_PATH=${4:-/data}

[ -z "$TEMPLATE_NAME" -o -z "$TEMPLATE_IMAGE" ] && printf 'Usage: %s \\\n\tTEMPLATE_NAME \\\n\tTEMPLATE_IMAGE \\\n\t[TEMPLATE_IMAGE_PORT (80)] \\\n\t[TEMPLATE_DATA_PATH (/data)]\n' "$0" && exit 1
[ -d "./$TEMPLATE_NAME" ] && echo "[ERROR] ./$TEMPLATE_NAME exists!" && exit 1

rm -rf /tmp/$TEMPLATE_NAME
cp -a $(realpath $(dirname "$0"))/data /tmp/$TEMPLATE_NAME
sudo mv /tmp/$TEMPLATE_NAME ./
cd ./$TEMPLATE_NAME

sed \
    -e "s#TEMPLATE_NAME#$TEMPLATE_NAME#g" \
    -e "s#TEMPLATE_IMAGE_PORT#$TEMPLATE_IMAGE_PORT#g" \
    -e "s#TEMPLATE_IMAGE#$TEMPLATE_IMAGE#g" \
    -e "s#TEMPLATE_DATA_PATH#$TEMPLATE_DATA_PATH#g" \
    -i ./docker-compose.yml

echo "[INFO] Success!"
