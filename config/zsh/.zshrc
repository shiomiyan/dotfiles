export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

# ================================
# Configure zsh and load extension
# ================================
source $ZDOTDIR/zi.zsh
setopt hist_ignore_dups
setopt sharehistory

# ================================
# Aliases
# ================================
alias ls="lsd"
alias la="lsd -la"

if [ -x "$(command -v xclip)" ]; then
    alias clip="xclip -sel clip"
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

# Gradle (manual install: https://gradle.org/install/#manually)
if [ -d "/opt/gradle/" ]; then
    export PATH="$PATH:/opt/gradle/$(ls /opt/gradle/)/bin"
fi

# npm
export PATH="$PATH:$HOME/.npm/bin"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Load local configuration
if [ -f "$ZDOTDIR/local.zsh" ]; then
    source "$ZDOTDIR/local.zsh"
else
    touch "$ZDOTDIR/local.zsh"
fi
