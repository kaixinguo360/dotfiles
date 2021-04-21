[ -n "$(command -v proxychains4)" ] && \
alias pbash='proxychains4 -q bash'
[ -n "$(command -v proxychains)" ] && \
alias pbash='proxychains bash'
