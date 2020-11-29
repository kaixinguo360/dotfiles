#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install helm"
    exit 0
fi

# Check Dependencies
only_support apt
has helm && [ "$1" != "-f" ] && echo 'helm installed' && exit 0
need k3s.sh

# Add source
curl  -f#SL https://baltocdn.com/helm/signing.asc | $sudo apt-key add -
$sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | $sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
$sudo apt-get update

# Install
install_pkg helm

# Add stable chart repository
printf 'Adding stable chart repository... ' \
    && $sudo helm repo add stable https://charts.helm.sh/stable >/dev/null 2>&1 \
    && printf 'done.\n'

# Add bash completion
printf 'Adding bash_completion... ' \
    && $sudo bash -ic 'helm completion bash 2>/dev/null >/etc/bash_completion.d/helm' \
    && printf 'done.\n'

# Add alias
[ -n "$SUDO" ] && {
printf 'Adding aliases to bashrc.d... ' \
    && mkdir -p $HOME/.local/bashrc.d \
    && echo "alias helm='sudo -E helm'" >> $HOME/.local/bashrc.d/99-helm.auto-generated.bashrc \
    && printf 'done.\n'
}

exit 0

