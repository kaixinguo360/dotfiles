#Git Alias

alias g='git'
_completion_loader git
complete -o bashdefault -o default -o nospace -F _git g

alias glog='git log'
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gc='git commit'
alias gcm='gc -m'
alias gadd='git add'
alias gadda='git add -A'
alias ga='gadda'
alias gpl='git pull'
alias gph='git push'
alias gfetch='git fetch'
alias gcheck='git checkout'
alias gdiff='git diff'
alias gcl='git clone'
alias gback='git reset HEAD^'
alias gup='gupdate'

gupdate() {
    if [ -z "$1" -o "${1:0:1}" = "-" ];then
        ga && gcm "Update At `date +%F-%T`" $@
    else
        MESG=$1
        shift
        ga && gcm "$MESG" $@
    fi
}

guph() {
    if [ -z "$1" -o "${1:0:1}" = "-" ];then
        gupdate
    else
        gupdate "$1"
        shift
    fi
    gph $@
}

