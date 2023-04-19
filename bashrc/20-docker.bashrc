# Docker Alias
[ -n "$(command -v docker)" ] && {

alias dc='docker'

alias dc-run="dc run \
    --rm -it \
    -v $HOME/dc/home:/root \
    -v $HOME/.dotfiles:/root/.dotfiles \
"

alias dc-exec='dc-run \
    -v $(pwd):$(pwd) \
    -w $(pwd) \
'

}

# Docker-Compose Alias
[ -n "$(command -v docker-compose)" ] && {

alias dcc='docker-compose'

}

