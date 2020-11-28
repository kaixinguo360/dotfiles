#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Remove k3s"
    exit 0
fi

# Check Dependencies
only_support $1 apt
not_has k3s && [ "$1" != "-f" ] && echo 'k3s removeed' && exit 0
[ "$1" = "-f" ] && shift

# Remove k3s
[ -x "/usr/local/bin/k3s-uninstall.sh" ] \
    && sudo /usr/local/bin/k3s-uninstall.sh
[ -x "/usr/local/bin/k3s-agent-uninstall.sh" ] \
    && sudo /usr/local/bin/k3s-agent-uninstall.sh

# Remove bash completion
printf 'Removing bash_completion of kubectl... ' \
    && sudo rm -f /etc/bash_completion.d/kubectl \
    && printf 'done.\n'
printf 'Removing bash_completion of crictl... ' \
    && sudo rm -f /etc/bash_completion.d/crictl \
    && printf 'done.\n'

# Close ports
close_port 6443/tcp  # [agent] Kubernetes API
close_port 8472/udp  # [server/agent] Required only for Flannel VXLAN
close_port 10250/tcp # [server/agent] kubelet

# Print Help
echo "Removed."

exit 0

