export LANG=ja_JP.UTF-8
PROMPT='%F{6}%c%f $ '

alias ..="cd .."
alias vi="vim"

# brew completion
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# enable input candidates
autoload -Uz compinit
compinit

# add color selected input candidates
zstyle ':completion:*:default' menu select=2

# Do not keep the same command history
setopt HIST_IGNORE_DUPS

# share history between processes
setopt share_history

# Added by Zplugin's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# add Zplugin's
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

case "$OSTYPE" in
  darwin*)
    alias pbc="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
  linux*)
  ;;
esac

# auto start tmux
if [[ ! -n $TMUX && $- == *l* ]]; then
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | fzf | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :
  fi
fi

# PATH exports
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
eval "$(anyenv init -)"
