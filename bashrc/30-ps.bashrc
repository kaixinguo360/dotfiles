# Ps Alias
alias ps-cpu='ps auxw|head -1;ps auxw|sort -rn -k3|head -10'
alias ps-mem='ps auxw|head -1;ps auxw|sort -rn -k4|head -10'
alias ps-swap='ps auxw|head -1;ps auxw|sort -rn -k5|head -10'

kall() {
    for PID in $@
    do
        ps -p $PID -o pgid --no-headers|xargs -i pkill -g {}
    done
}
