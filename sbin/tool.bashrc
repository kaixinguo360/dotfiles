# Bash-Completion #

complete -F _installable_tools tool-install
complete -F _installable_tools tool-installs

complete -F _removable_tools tool-remove
complete -F _removable_tools tool-removes

complete -F _installable_tools tool-install-edit
complete -F _removable_tools tool-remove-edit

complete -F _installable_tools tool-test

complete -F _installable_templates tool-template

# Bash-Completion Function #

function _installable_tools() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    lists=$(find-resource --name 'list/*.list')
    scripts=$(find-resource --name 'script/install_*.sh'|sed 's/^.*install_//'|sed '/tool.sh/d')
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

    lists=$(find-resource --name 'list/*.list')
    scripts=$(find-resource --name 'script/remove_*.sh'|sed 's/^.*remove_//'|sed '/tool.sh/d')
    opts="-i $lists $scripts"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

function _installable_templates() {
    local cur prev opts lists scripts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    templates=$(find-resource --name 'templates/*')
    opts="$templates"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

