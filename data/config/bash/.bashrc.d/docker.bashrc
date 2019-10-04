# Docker Alias
alias dc='docker'
_completion_loader docker
complete -F _docker dc

alias dcc='docker-compose'
complete -F _docker_compose dcc
