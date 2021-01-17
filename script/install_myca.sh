#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install rgit"
    exit 0
fi

# Check Dependencies
only_support apt
has myca.sh && [ "$1" != "-f" ] && echo 'myca installed' && exit 0
need git expect
[ "$1" = "-f" ] && shift

# Read Input
read_input \
    MYCA_PATH str 'Path' '/opt/myca' \
    MYCA_COMMON_NAME str 'Common Name' $DEFAULT_HOST_NAME \
    MYCA_ROOT_PASSWORD pass 'Root Password' $DEFAULT_PASSWORD \
    MYCA_EMAIL str 'E-Mail' ${USER}@${DEFAULT_HOST_NAME}

# Download && Run init.sh
$SUDO git clone https://github.com/kaixinguo360/MyCA.git $MYCA_PATH
$SUDO $MYCA_PATH/install/init.sh $MYCA_ROOT_PASSWORD $MYCA_COMMON_NAME $MYCA_EMAIL

# Create Soft Link
$SUDO rm /usr/local/bin/myca.sh
$SUDO ln -s $MYCA_PATH/myca.sh /usr/local/bin
