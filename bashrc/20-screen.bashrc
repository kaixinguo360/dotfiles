# Screen Alias
[ -n "$(command -v screen)" ] && {

alias scl='screen -ls'
alias scs='screen -S'
alias scr='screen -r'
alias cleanscreen="screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs -I{} screen -S {} -X quit"

}
