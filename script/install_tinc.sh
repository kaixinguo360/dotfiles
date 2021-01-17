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
has scp ssh || { echo "Can't find 'scp' and 'ssh' command, please install them."; exit 1; }
[ "$1" = "-f" ] && shift

# Read Input
read_input \
    TINC_VNET_NAME  str 'Vnet name' 'mynet' \
    TINC_VNET_ADDR  str 'Vnet address' '10.0.0.0/24' \
    TINC_VHOST_NAME str 'Vhost name' $DEFAULT_HOST_NAME \
    TINC_VHOST_ADDR str 'Vhost address' '10.0.0.1'
TINC_VHOST_ADDR=$TINC_VHOST_ADDR/32

read_input TINC_IS_SYNC bool 'Sync configs from other host?' y
[ "$TINC_IS_SYNC" == 'y' ] && read_input \
    TINC_SYNC_FROM str 'Address of host to sync' 'k'

read_input TINC_IS_FIXED_ADDR bool 'Is this host has fixed address?' n
[ "$TINC_IS_FIXED_ADDR" == 'y' ] && read_input \
    TINC_FIXED_ADDR str 'Fixed address of this host' '127.0.0.1'

###############
# Install tinc
###############
install_tool tinc || { echo "tinc installation failed"; exit 1; }

TINC_CONF_ROOT=/etc/tinc
NET_ROOT=$TINC_CONF_ROOT/$TINC_VNET_NAME

###############
# Sync hosts
###############
$SUDO rm -rf $NET_ROOT/hosts
$SUDO mkdir -p $NET_ROOT/hosts
$SUDO chown $USER -R $NET_ROOT
[ "$TINC_IS_SYNC" == 'y' ] && {
echo -n "Syncing configs... "
scp -q $TINC_SYNC_FROM:/etc/tinc/$TINC_VNET_NAME/hosts/* $NET_ROOT/hosts \
    && echo 'done.' || exit 1
}

###############
# Basic Config
###############

# Create tinc-up
cat > $NET_ROOT/tinc-up << HERE
#!/bin/sh
ip link set \$INTERFACE up
ip addr add $TINC_VHOST_ADDR dev \$INTERFACE
ip route add $TINC_VNET_ADDR dev \$INTERFACE
HERE
chmod +x $NET_ROOT/tinc-up

# Create tinc-down
cat > $NET_ROOT/tinc-down << HERE
#!/bin/sh
ip route del $TINC_VNET_ADDR dev \$INTERFACE
ip addr del $TINC_VHOST_ADDR dev \$INTERFACE
ip link set \$INTERFACE down
HERE
chmod +x $NET_ROOT/tinc-down

# Create tinc.conf
cat > $NET_ROOT/tinc.conf << HERE
Name = $TINC_VHOST_NAME
Device = /dev/net/tun
HERE
[ "$TINC_IS_SYNC" == 'y' ] && (
cd $NET_ROOT/hosts
rm -f $TINC_VHOST_NAM
grep -e '^\s*Address\s*=' * -l | \
    awk '{print "ConnectTo = "$1}' | \
    cat >> $NET_ROOT/tinc.conf
)

###############
# Config hosts
###############

# Create hosts/* config
cat > $NET_ROOT/hosts/$TINC_VHOST_NAME << HERE
Port = 655
Subnet = $TINC_VHOST_ADDR
HERE
[ "$TINC_IS_FIXED_ADDR" == 'y' ] && \
cat >> $NET_ROOT/hosts/$TINC_VHOST_NAME << HERE
Address = $TINC_FIXED_ADDR
HERE

# Generate RSA key
rm -f $NET_ROOT/rsa_key.priv
yes|$SUDO tincd -n $TINC_VNET_NAME -K

# Rectify permissions
$SUDO chown root -R $NET_ROOT
$SUDO chown $USER -R $NET_ROOT/hosts
chmod 644 $NET_ROOT/hosts/*

# Sync to remote host
[ "$TINC_IS_SYNC" == 'y' ] && {
echo -n "Update configs... "
scp -q $NET_ROOT/hosts/$TINC_VHOST_NAME $TINC_SYNC_FROM:/etc/tinc/$TINC_VNET_NAME/hosts \
    && echo 'done.' || exit 1
}

# Add $TINC_VNET_NAME to config
printf 'Enabling config... ' \
    && sudo bash -ic "echo $TINC_VNET_NAME>/etc/tinc/nets.boot" \
    && printf 'done.\n'

# Expose ports
expose_port 655/tcp

# Start Service
start_service tinc

