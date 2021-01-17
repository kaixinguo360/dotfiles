# Includ bin #

PATH="$(realpath $HOME/.bashrc.d)/../../../sbin:$PATH"

# Bash-Completion #

complete -F _installable_tools tool-install
complete -F _installable_tools tool-installs

complete -F _removable_tools tool-remove
complete -F _removable_tools tool-removes

complete -F _installable_tools tool-install-edit
complete -F _removable_tools tool-remove-edit

complete -F _installable_tools tool-test

# Bash-Completion Function #

function _installable_tools() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    DOT_ROOT="$(realpath $HOME/.bashrc.d)/../../.."
    lists=$(list-resource list '*.list')
    scripts=$(list-resource script 'install_*.sh'|sed 's/^.*install_//'|sed '/tool.sh/d')
    opts="-i $lists $scripts"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

function _removable_tools() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    DOT_ROOT="$(realpath $HOME/.bashrc.d)/../../.."
    lists=$(list-resource list '*.list')
    scripts=$(list-resource script 'remove_*.sh'|sed 's/^.*remove_//'|sed '/tool.sh/d')
    opts="-i $lists $scripts"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

