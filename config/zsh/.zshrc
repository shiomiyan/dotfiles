export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

# ================================
# Configure zsh and load extension
# ================================
eval "$(sheldon source)"
setopt hist_ignore_dups
setopt sharehistory
if [ ! -d "$XDG_CACHE_HOME"/zsh ]; then
    mkdir -p "$XDG_CACHE_HOME"/zsh
fi
if [ ! -d "$XDG_STATE_HOME"/zsh ]; then
    mkdir -p "$XDG_STATE_HOME"/zsh
fi
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
export HISTFILE="$XDG_STATE_HOME"/zsh/history

# ================================
# Aliases
# ================================
if [ -x "$(command -v xclip)" ]; then
    alias clip="xclip -sel clip"
fi

if [ -x "$(command -v docker)" ]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
fi

if [[ $(uname) == "Darwin" ]]; then
    alias clip="pbcopy"
    alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

# ================================
# Load config for WSL
# ================================
if uname -r | grep -q 'microsoft'; then
    source $ZDOTDIR/wsl.zsh
fi

# ================================
# Settings for toolchains
# ================================
export PATH="$HOME/.local/bin:$PATH"

# less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# GnuPG
export GPG_TTY=$(tty)

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Golang
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Gradle (manual install: https://gradle.org/install/#manually)
if [ -d "/opt/gradle/" ]; then
    export PATH="$PATH:/opt/gradle/$(ls /opt/gradle/)/bin"
fi

# npm
export PATH="$PATH:$HOME/.npm/bin"
if [ -x "$(command -v npm)" ]; then
    eval "$(npm completion)"
fi

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"

# Load local configuration
if [ -f "$ZDOTDIR/local.zsh" ]; then
    source "$ZDOTDIR/local.zsh"
else
    touch "$ZDOTDIR/local.zsh"
fi

# mise
eval "$(mise activate zsh --shims)"


. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"

export SSH_AUTH_SOCK="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"


. "$HOME/.local/share/../bin/env"
