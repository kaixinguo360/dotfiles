#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rclone"
    exit 0
fi

# Check Dependencies
has rclone && [ "$1" != "-f" ] && echo 'rclone installed' && exit 0
need curl unzip

# Set URL and Local Bin Path
if [ "$PMG" = "termux" ]; then
    ARCH="arm64"
    LOCAL=$PREFIX/bin/rclone
else
    ARCH="amd64"
    LOCAL=/usr/local/bin/rclone
fi
#URL="https://downloads.rclone.org/rclone-current-linux-${ARCH}.zip";
URL="https://downloads.rclone.org/v1.61.1/rclone-v1.61.1-linux-${ARCH}.zip";

# Download
$sudo rm -rf "$TMP_PATH/tmp_rclone" "$TMP_PATH/tmp_rclone.zip"
download "$URL" "$TMP_PATH/tmp_rclone.zip" 644 \
    && mkdir -p "$TMP_PATH/tmp_rclone" \
    && cd "$TMP_PATH/tmp_rclone" \
    && echo -n "Extracting... " \
    && unzip -qq "$TMP_PATH/tmp_rclone.zip" \
    && echo "done." \
    && cd rclone-v*-linux-* \
    && $sudo cp ./rclone "$LOCAL" \
    && $sudo chmod 755 "$LOCAL" \
    && echo -n "Cleaning... " \
    && $sudo rm -rf "$TMP_PATH/tmp_rclone" "$TMP_PATH/tmp_rclone.zip" \
    && echo "done." \
    && echo "Rclone has been installed to $LOCAL" \
    && echo "See 'rclone --help' to read help info."

