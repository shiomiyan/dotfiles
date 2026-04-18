export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

export PATH="$HOME/.local/bin:$PATH"

typeset -U path PATH

export GPG_TTY=$(tty)

if [[ -x "$(command -v docker)" ]]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
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

export LESSHISTFILE="$XDG_STATE_HOME"/less/history

[[ -d "$HOME/go/bin" ]] && export PATH="$PATH:$HOME/go/bin"

if [[ -x "$(command -v opam)" ]]; then
    [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
fi

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh" || touch "$ZDOTDIR/local.zsh"
