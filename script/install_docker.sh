#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install docker"
    exit 0
fi

# Check Dependencies
not_support_docker $1
has docker && [ "$1" != "-f" ] && echo 'docker installed' && exit 0
need curl ca-certificates @apt:apt-transport-https

# Download && Run script.sh
cd \
    && curl -f#SL https://get.docker.com -o get-docker.sh \
    && $SUDO sh get-docker.sh
rm -f get-docker.sh

restart_service docker

# Executing the Docker Command Without Sudo
echo -e "\nMaybe you should use this command to add specified user to docker group"
echo -e "\n  $SUDO usermod -aG docker ${USER:-<your_user_name>}\n"
[ -n "$USER" ] && $SUDO usermod -aG docker $USER
exit 0

