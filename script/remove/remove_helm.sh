#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove helm"
    exit 0
fi

# Check Dependencies
only_support apt
not_has helm && [ "$1" != "-f" ] && echo 'helm removed' && exit 0

# Remove
remove_pkg helm

# Remove source
$sudo rm -f /etc/apt/sources.list.d/helm-stable-debian.list
$sudo apt-get update

# Remove data
printf 'Removing data... ' \
    && $sudo rm -rf $HOME/.cache/helm \
    && $sudo rm -rf $HOME/.config/helm \
    && $sudo rm -rf $HOME/.local/share/helm \
    && printf 'done.\n'

# Remove bash completion
printf 'Removing bash_completion... ' \
    && $sudo rm -f /etc/bash_completion.d/helm \
    && printf 'done.\n'

# Remove alias
[ -n "$SUDO" ] && {
printf 'Removing aliases from bashrc.d... ' \
    && mkdir -p $HOME/.local/bashrc.d \
    && rm -f $HOME/.local/bashrc.d/99-helm.auto-generated.bashrc \
    && printf 'done.\n'
}

# Print result
echo "Removed."

exit 0

