# Docker Alias
[ -n "$(command -v docker)" ] && {
alias dc='docker'
_completion_loader docker
complete -F _docker dc
}

[ -n "$(command -v docker-compose)" ] && {
alias dcc='docker-compose'
complete -F _docker_compose dcc
}
