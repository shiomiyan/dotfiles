export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

# setup zsh plugin
eval "$(sheldon source)"

# distinct duplicate command history
setopt hist_ignore_dups

# share history
setopt sharehistory

# remove duplicate PATH
typeset -U path PATH

# atuin
if [[ -x "$(command -v atuin)" ]]; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# GPG
export GPG_TTY=$(tty)

# docker utility command if docker exists
if [[ -x "$(command -v docker)" ]]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
fi

# copy text (example: echo "hello world" | clip)
if [[ -x "$(command -v xclip)" ]]; then
    alias clip="xclip -sel clip"
fi

# `open` command
if [[ -x "$(command -v xdg-open)" ]]; then
    alias open="xdg-open"
fi

if [[ $(uname) == "Darwin" ]]; then
    alias clip="pbcopy"
    alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

# load config for WSL
if [[ "$(uname -r)" =~ 'microsoft' ]]; then
    source $ZDOTDIR/wsl.zsh
fi

# set path for executables
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# starship
if [[ -x "$(command -v starship)" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    eval "$(starship init zsh)"
fi

# zoxide
if [[ -x "$(command -v zoxide)" ]]; then
    eval "$(zoxide init zsh)"
fi

# rust
[[ -d "$HOME/.cargo" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# golang
[[ -d "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"
[[ -d "$HOME/go/bin" ]] && export PATH="$PATH:$HOME/go/bin"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# npm
if [[ -x "$(command -v npm)" ]]; then
    export PATH="$PATH:$HOME/.npm/bin"
    eval "$(npm completion)"
fi

# pnpm
if [[ -x "$(command -v pnpm)" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    alias pp="pnpm"
fi

# ocaml
if [[ -x "$(command -v opam)" ]]; then
    [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
fi

# llvm
[[ -d "/usr/local/opt/llvm/bin" ]] && export PATH="/usr/local/opt/llvm/bin:$PATH"

# load local configuration / create local configuration file if not exists
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh" || touch "$ZDOTDIR/local.zsh"

# mise
if [[ -x "$(command -v mise)" ]]; then
    eval "$(mise activate zsh --shims)"
fi
