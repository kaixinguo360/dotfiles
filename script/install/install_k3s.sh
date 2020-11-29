#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Show Help Info
if [[ $1 = "-h" || $1 = "--help" ]];then
    echo -e "Install k3s"
    exit 0
fi

# Check Dependencies
has k3s && [ "$1" != "-f" ] && echo 'k3s installed' && exit 0
need docker.sh

# Read Input
read_input \
    K3S_IS_SERVER bool '[1/1] This node is server(Y) or agent(N)' y
[ ! "$K3S_IS_SERVER" == "y" ] && read_input \
    K3S_URL str '[2/3] K3S_URL' '-' \
    K3S_TOKEN str '[3/3] K3S_TOKEN' '-' \

# Download && Run script.sh
download_and_run \
    https://get.k3s.io \
    get-k3s.sh \
    --docker

# Add bash completion
printf 'Adding bash_completion of kubectl... ' \
    && $sudo bash -ic 'kubectl completion bash 2>/dev/null >/etc/bash_completion.d/kubectl' \
    && printf 'done.\n'
printf 'Adding bash_completion of crictl... ' \
    && $sudo bash -ic 'crictl completion bash 2>/dev/null >/etc/bash_completion.d/crictl' \
    && printf 'done.\n'

# Add env
printf 'Adding env to bashrc.d... ' \
    && mkdir -p $HOME/.local/bashrc.d \
    && echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.local/bashrc.d/99-k3s.auto-generated.bashrc \
    && printf 'done.\n'

# Add alias
[ -n "$SUDO" ] && {
printf 'Adding aliases to bashrc.d... ' \
    && echo "alias kubectl='sudo -E kubectl'" >> $HOME/.local/bashrc.d/99-k3s.auto-generated.bashrc \
    && echo "alias crictl='sudo -E crictl'" >> $HOME/.local/bashrc.d/99-k3s.auto-generated.bashrc \
    && echo "alias ctr='sudo -E ctr'" >> $HOME/.local/bashrc.d/99-k3s.auto-generated.bashrc \
    && printf 'done.\n'
}

# Expose ports
expose_port 6443/tcp  # [agent] Kubernetes API
expose_port 8472/udp  # [server/agent] Required only for Flannel VXLAN
expose_port 10250/tcp # [server/agent] kubelet

