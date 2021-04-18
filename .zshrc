export LANG=ja_JP.UTF-8

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk

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
export PATH="$HOME/.anyenv/bin:$PATH"
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(anyenv init -)"
eval "$(starship init zsh)"
