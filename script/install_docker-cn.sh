#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install docker with cn mirrors"
    exit 0
fi

# Check Dependencies
not_support_docker $1
only_support $1 apt
has docker && [ "$1" != "-f" ] && echo 'docker installed' && exit 0
need curl apt-transport-https ca-certificates

# Add apt source mirror
$sudo sh -c "echo 'deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable' > /etc/apt/sources.list.d/docker.list"
$sudo sh -c "curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -"

# Install docker
install_pkg docker-ce

# Add docker registry mirror
echo -n "Changing docker-hub source to 'docker.mirrors.ustc.edu.cn'... "
$sudo sh << HERE
echo '{
    "registry-mirrors": [
        "https://docker.mirrors.ustc.edu.cn/"
    ]
}' > /etc/docker/daemon.json
HERE
[ $? = 0 ] && echo "done." || exit 1
restart_service docker

# Executing the Docker Command Without Sudo
echo -e "\nMaybe you should use this command to add specified user to docker group"
echo -e "\n  $SUDO usermod -aG docker $USER\n"
[ -n "$USER" ] && $SUDO usermod -aG docker $USER
exit 0

