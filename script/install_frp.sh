#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install frp"
    exit 0
fi

# Check Dependencies
has frpc && [ "$1" != "-f" ] && echo 'frp installed' && exit 0
need curl unzip

# Set URL and Local Bin Path
if [ "$PMG" = "termux" ]; then
    ARCH="arm64"
    BIN_LOCAL=$PREFIX/bin
    ETC_LOCAL=$PREFIX/etc
else
    ARCH="amd64"
    BIN_LOCAL=/usr/local/bin
    ETC_LOCAL=/etc
fi
URL="https://github.com/fatedier/frp/releases/download/v0.44.0/frp_0.44.0_linux_${ARCH}.tar.gz";

# Download
$sudo rm -rf "$TMP_PATH/tmp_frp" "$TMP_PATH/tmp_frp.tar.gz"
download "$URL" "$TMP_PATH/tmp_frp.tar.gz" 644 \
    && mkdir -p "$TMP_PATH/tmp_frp" \
    && cd "$TMP_PATH/tmp_frp" \
    && echo -n "Extracting... " \
    && tar -zxpf "$TMP_PATH/tmp_frp.tar.gz" \
    && echo "done." \
    && cd frp_*_linux_* \
    && $sudo cp ./frpc "$BIN_LOCAL/frpc" \
    && $sudo cp ./frps "$BIN_LOCAL/frps" \
    && $sudo mkdir -p "$ETC_LOCAL/frp" \
    && $sudo cp ./*.ini "$ETC_LOCAL/frp" \
    && $sudo chmod 755 "$BIN_LOCAL/frpc" \
    && $sudo chmod 755 "$BIN_LOCAL/frps" \
    && echo -n "Cleaning... " \
    && $sudo rm -rf "$TMP_PATH/tmp_frp" "$TMP_PATH/tmp_frp.tar.gz" \
    && echo "done." \
    && echo "Frp has been installed to $BIN_LOCAL/frpc and $BIN_LOCAL/frps" \
    && echo "See 'frpc --help' or 'frps --help' to read help info."

