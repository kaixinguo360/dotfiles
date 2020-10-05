# Alias
alias c=clear
alias cd..='cd ..'
alias vi=vim
alias sl='sl -e'
alias dul='sudo du -ha --max-depth=1'
alias dfh='df -h'
alias se='sudo service'
alias rnginx='sudo nginx -t && se nginx restart'
alias ca='cacaview'
alias untar='tar -zxpf'
alias reloadbashrc='source ~/.bashrc'
alias updot='upgradedotfile'
alias upgradedotfile='(cd $HOME/.bashrc.d; \
    git fetch --all && \
    git reset --hard origin/master && \
    git pull) && \
    reloadbashrc'
alias bench.sh='curl -Lso- bench.sh | bash'
s() { sudo bash -ic "$*"; }
complete -F _command s
forceumount() { fusermount -u $1 || sudo umount -l $1; }
