# Alias
alias c=clear
alias py=python3
alias py3=python3
alias py2=python2
alias cd..='cd ..'
alias sl='sl -e'
alias dul='sudo du -ha --max-depth=1'
alias dfh='df -h'
alias se='sudo service'
alias ca='cacaview'
alias untar='tar -zxpf'
alias reloadbashrc='source ~/.bashrc'
alias updot='upgradedotfile'
alias upgradedotfile='(cd $HOME/.bashrc.d; \
git fetch --all && \
git reset --hard origin/master && \
git pull) && \
reloadbashrc'
