# Add grey hostname block (%M)
export PROMPT='$(git_custom_status)%F{244}[%M]%{$fg[cyan]%}[%~% ]%{$reset_color%}%B$%b '

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    ''${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# Run ranger using Ctrl+N.
# ^n = Ctrl+N
# ^u = Ctrl+U
# ^M = Return
bindkey -s '^n' '^uranger^M'

if (( $+commands[exa] )); then
    alias ls="exa"
    alias ll="exa -l"
    alias lt="exa -lT"
    alias lg="exa -lG"
fi

# Load 3rdparty auto-completions
if (( $+commands[aws_completer] )); then
    complete -C $(which aws_completer) aws
fi

if (( $+commands[kubectl] )); then
    source <(kubectl completion zsh)
fi
