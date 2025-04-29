export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

# ================================
# Configure zsh and load extension
# ================================
# setup zsh plugin
eval "$(sheldon source)"

# distinct duplicate command history
setopt hist_ignore_dups

# share history
setopt sharehistory

# remove duplicate PATH
typeset -U path PATH

# setup cache directory depends on xdg base directory
[[ ! -d "$XDG_CACHE_HOME"/zsh ]] && mkdir -p "$XDG_CACHE_HOME"/zsh
[[ ! -d "$XDG_STATE_HOME"/zsh ]] && mkdir -p "$XDG_STATE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
export HISTFILE="$XDG_STATE_HOME"/zsh/history

# docker utility command if docker exists
if [ -x "$(command -v docker)" ]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
fi

if [ -x "$(command -v xclip)" ]; then
    alias clip="xclip -sel clip"
fi

if [[ $(uname) == "Darwin" ]]; then
    alias clip="pbcopy"
    alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

# load config for WSL
if uname -r | grep -q 'microsoft'; then
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

# GnuPG
export GPG_TTY=$(tty)

# Rust
[[ -d "$HOME/.cargo" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Gradle (manual install: https://gradle.org/install/#manually)
[[ -d "/opt/gradle/" ]] && export PATH="$PATH:/opt/gradle/$(ls /opt/gradle/)/bin"

# npm
if [ -x "$(command -v npm)" ]; then
    export PATH="$PATH:$HOME/.npm/bin"
    eval "$(npm completion)"
fi

# pnpm
if [ -x "$(command -v pnpm)" ]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi

# llvm
[[ -d "/usr/local/opt/llvm/bin" ]] && export PATH="/usr/local/opt/llvm/bin:$PATH"

# Load local configuration
[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh" || touch "$ZDOTDIR/local.zsh"

# mise
if [ -x "$(command -v mise)" ]; then
    eval "$(mise activate zsh --shims)"
fi

# atuin
if [ -x "$(command -v atuin)" ]; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

