# Pollfill
if [ -z "$(command -v _completion_loader)" ]; then
    alias _completion_loader=':'
    alias complete=':'
else
    _dotfiles_completion_loader () {
        local cmd="${1:-_EmptycmD_}";
        local alias_cmd="$(alias | grep "alias $cmd=" | sed -E "s#^alias $cmd='(.*)'\$#\\1#g")"
        if [ -n "$alias_cmd" -a -z "$(printf '%s' "$alias_cmd" | grep ' ')" ]; then
            _completion_loader "$alias_cmd"
            command -v "_$alias_cmd" >/dev/null 2>&1 && complete -F "_$alias_cmd" -- "$cmd" && return 124
            complete -F _minimal -- "$cmd" && return 124
        else
            _completion_loader "$cmd"
        fi
    }
    complete -D -F _dotfiles_completion_loader
fi

