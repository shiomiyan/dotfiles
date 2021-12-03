export LANG=ja_JP.UTF-8

alias ..="cd .."
alias vi="vim"

case "$OSTYPE" in
  darwin*)
    alias clip="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
  ;;
  linux*)
  ;;
esac

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop  ]; then
  alias clip="clip.exe";
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

# PATH exports
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"
