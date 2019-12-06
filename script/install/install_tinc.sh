#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install tinc"
    exit 0
fi

# Check Dependencies
only_support $1 apt apk
has tincd && [ "$1" != "-f" ] && echo 'tinc installed' && exit 0
[ "$1" = "-f" ] && shift

# Read Input
read_input \
    TINC_VNET_NAME  str 'Vnet name' 'mynet' \
    TINC_VNET_ADDR  str 'Vnet address' '192.168.1.0/24' \
    TINC_VHOST_NAME str 'Vhost name' $DEFAULT_HOST_NAME \
    TINC_VHOST_ADDR str 'Vhost address' '192.168.1.1/32' \
    TINC_IS_CONNECT bool 'Connect to other host?' n
[ "$TINC_IS_CONNECT" == 'y' ] && read_input \
    TINC_CONNECT_TO str 'Address of host to connect' $DEFAULT_HOST_NAME
[ "$TINC_IS_CONNECT" != 'y' ] && read_input \
    TINC_LOCAL_ADDR str 'Address of this host' '127.0.0.1'

# Install
install_tool tinc || { echo "tinc installation failed"; exit 1; }

## Config Tincd ##

TINC_CONF_ROOT=/etc/tinc
NET_ROOT=$TINC_CONF_ROOT/$TINC_VNET_NAME

# Create config directory
$SUDO mkdir -p $NET_ROOT/hosts
$SUDO rm -f $NET_ROOT/hosts/*

# Create tinc-up
$SUDO touch $NET_ROOT/tinc-up
$SUDO chmod 777 $NET_ROOT/tinc-up
cat > $NET_ROOT/tinc-up << HERE
#!/bin/sh
ip link set \$INTERFACE up
ip addr add $TINC_VHOST_ADDR dev \$INTERFACE
ip route add $TINC_VNET_ADDR dev \$INTERFACE
HERE
$SUDO chmod 755 $NET_ROOT/tinc-up

# Create tinc-down
$SUDO touch $NET_ROOT/tinc-down
$SUDO chmod 777 $NET_ROOT/tinc-down
cat > $NET_ROOT/tinc-down << HERE
#!/bin/sh
ip route del $TINC_VNET_ADDR dev \$INTERFACE
ip addr del $TINC_VHOST_ADDR dev \$INTERFACE
ip link set \$INTERFACE down
HERE
$SUDO chmod 755 $NET_ROOT/tinc-down

# Create tinc.conf
$SUDO touch $NET_ROOT/tinc.conf
$SUDO chmod 777 $NET_ROOT/tinc.conf
cat > $NET_ROOT/tinc.conf << HERE
Name = $TINC_VHOST_NAME
Device = /dev/net/tun
HERE
[ "$TINC_IS_CONNECT" == 'y' ] && \
cat >> $NET_ROOT/tinc.conf << HERE
ConnectTo = $TINC_CONNECT_TO
HERE
$SUDO chmod 644 $NET_ROOT/tinc.conf

# Create hosts/* config
$SUDO touch $NET_ROOT/hosts/$TINC_VHOST_NAME
$SUDO chmod 777 $NET_ROOT/hosts/$TINC_VHOST_NAME
[ "$TINC_IS_CONNECT" != 'y' ] && \
cat > $NET_ROOT/hosts/$TINC_VHOST_NAME << HERE
Address = $TINC_LOCAL_ADDR
HERE
cat > $NET_ROOT/hosts/$TINC_VHOST_NAME << HERE
Port = 655
Subnet = $TINC_VHOST_ADDR
HERE
$SUDO chmod 644 $NET_ROOT/hosts/$TINC_VHOST_NAME

# Create RSA key
$SUDO rm -f $NET_ROOT/rsa_key.priv
yes|$SUDO tincd -n $TINC_VNET_NAME -K
$SUDO chmod 644 $NET_ROOT/hosts/*


