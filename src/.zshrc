export LC_MESSAGES=en_US.UTF-8

case "$OSTYPE" in
  darwin*)
    alias clip="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
  ;;
  linux*)
  ;;
esac

if [ `uname -r | grep microsoft` ]; then
  alias win32yank="/mnt/c/Tools/win32yank/win32yank.exe"
  alias clip="win32yank -i"
  export PATH="/mnt/c/Users/sk/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
fi

# auto start tmux
#if [[ ! -n $TMUX && $- == *l* ]]; then
#  ID="`tmux list-sessions`"
#  if [[ -z "$ID" ]]; then
#    tmux new-session
#  fi
#  create_new_session="Create New Session"
#  ID="$ID\n${create_new_session}:"
#  ID="`echo $ID | fzf | cut -d: -f1`"
#  if [[ "$ID" = "${create_new_session}" ]]; then
#    tmux new-session
#  elif [[ -n "$ID" ]]; then
#    tmux attach-session -t "$ID"
#  else
#    :
#  fi
#fi



# Rust
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
