
function _installable_tools() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    DOT_ROOT="$(realpath $HOME/.bashrc.d)/../../../.."
    lists=$(ls "$DOT_ROOT/data/pkg")
    scripts=$(ls "$DOT_ROOT"/script/install/install_*.sh|sed 's/^.*install_//'|sed '/tool.sh/d')
    opts="-i $lists $scripts"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _installable_tools install-tool
complete -F _installable_tools install-tools
