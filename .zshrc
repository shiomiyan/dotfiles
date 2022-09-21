export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

source ~/.config/zsh/zi.zsh
setopt hist_ignore_dups
setopt sharehistory

if [[ `uname` == "Darwin" ]]; then
  alias clip="pbcopy"
  alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

# Settings for WSL
if command -v wslpath &> /dev/null; then
  alias clip="/mnt/c/tools/neovim/nvim-win64/bin/win32yank.exe -i"
  # appendWindowsPath is set to false in wsl.conf
  export PATH="/mnt/c/Users/sk/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ==== Settings for toolchains ===
# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Golang
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# show hidden files with fzf.vim
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'

# nix
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . /home/sk/.nix-profile/etc/profile.d/nix.sh
fi

# zoxide
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
