export GPG_TTY=$(tty)

typeset -U path PATH

if [[ -x "$(command -v docker)" ]]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
fi

if [[ -x "$(command -v ghq)" && -x "$(command -v fzf)" ]]; then
    function g() {
        local repo
        repo="$(ghq list --full-path | fzf)" || return
        [[ -n "$repo" ]] && cd "$repo"
    }

    function ghq-fzf-widget() {
        g
        zle reset-prompt
    }

    zle -N ghq-fzf-widget
    bindkey '^G' ghq-fzf-widget
fi

if [[ -x "$(command -v xclip)" ]]; then
    alias clip="xclip -sel clip"
fi

if [[ -x "$(command -v xdg-open)" ]]; then
    alias open="xdg-open"
fi

if [[ $(uname) == "Darwin" ]]; then
    alias clip="pbcopy"
    alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

if [[ "$(uname -r)" =~ 'microsoft' ]]; then
    source "$ZDOTDIR/wsl.zsh"
fi

[[ -d "$HOME/go/bin" ]] && export PATH="$PATH:$HOME/go/bin"

if [[ -x "$(command -v opam)" ]]; then
    [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
fi

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh" || touch "$ZDOTDIR/local.zsh"
