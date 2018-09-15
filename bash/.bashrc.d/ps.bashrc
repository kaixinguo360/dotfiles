# Ps Alias
alias ps-cpu='ps auxw|head -1;ps auxw|sort -rn -k3|head -10'
alias ps-mem='ps auxw|head -1;ps auxw|sort -rn -k4|head -10'
alias ps-swap='ps auxw|head -1;ps auxw|sort -rn -k5|head -10'
