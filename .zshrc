export LANG=ja_JP.UTF-8

autoload -Uz add-zsh-hook vcs_info compinit
compinit
add-zsh-hook precmd vcs_info

setopt HIST_IGNORE_DUPS
setopt share_history
setopt prompt_subst

# add color selected input candidates
zstyle ':completion:*:default' menu select=2
# set git branch status on prompt
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '(%b%u%c)'
zstyle ':vcs_info:*' actionformats '(%b|%a%u%c)'

PROMPT='%F{6}%c%f %F{red}${vcs_info_msg_0_}%f $ '

alias ..="cd .."
alias vi="vim"

case "$OSTYPE" in
  darwin*)
    alias pbc="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
  ;;
  linux*)
  ;;
esac

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

