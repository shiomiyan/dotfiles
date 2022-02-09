export LC_MESSAGES=en_US.UTF-8

source ~/.config/zsh/zi.zsh

case "$OSTYPE" in
  darwin*)
    alias clip="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
  ;;
  linux*)
  ;;
esac

if [ `uname -r | grep microsoft` ]; then
  alias clip="win32yank -i"
  alias cmd="/mnt/c/Windows/System32/cmd.exe"
  export PATH="/mnt/c/Users/sk/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Go lang
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# show hidden files with fzf.vim
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'

# nix
. /home/sk/.nix-profile/etc/profile.d/nix.sh

