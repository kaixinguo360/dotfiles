# Bash-Completion #

complete -F _tool-activate tool-activate

# Bash-Completion Function #

function _tool-activate() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts=$(find-resource --name 'dc-tool/*')

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

