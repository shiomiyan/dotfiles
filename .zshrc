export LANG=ja_JP.UTF-8
PROMPT='%F{6}%c%f $ '

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

# zsh pure prompt theme enable -> clear "#" bottom two lines
# autoload -U promptinit; promptinit
# prompt pure

# Added by Zplugin's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# End of Zplugin's installer chunk

# add Zplugin's
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# config starship
eval "$(starship init zsh)"

# alias
alias ..="cd .."
alias cdd="cd ~/dev"
alias pbc="pbcopy"
alias jl="jupyter lab"
alias v="vim"
alias vi="vim"
alias g="git"
alias python="python3"
alias pip="pip3"
alias exa="exa --group-directories-first"
alias rb="ruby"
alias lc="leetcode"
alias typora="open /Applications/Typora.app"
alias py="python"
alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
function blog() {
  cd "$HOME/dev/blog/"
  hexo new $1
  vi "./source/_posts/$1.md"
}
function atc() {
  command rustc $1 -o atcexe && ./atcexe
}

export PATH="/usr/local/bin:$PATH"

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


# cargo path
export PATH="$HOME/.cargo/bin:$PATH"

# binutils
export PATH="/usr/local/opt/binutils/bin:$PATH"

# laravel path setting
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Open MPI: Version 2.0.4 path configuration
export PATH="$HOME/opt/usr/local/bin/:$PATH"

# AWS CLI configuration
export PATH="$HOME/.local/bin:$PATH"

# cloud_sql_proxy (GCP)
export PATH="$HOME/:$PATH"

# Go lang
export GOPATH="$HOME/go/"
export PATH="$GOPATH/bin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# auto start tmux
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
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
    :  # Start terminal normally
  fi
fi

# llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"

# gcc - g++
export PATH=$PATH:/usr/local/bin

#=======================================================#

# profiling zsh bottle necks
#if (which zprof > /dev/null 2>&1) ;then
#    zprof
#fi



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sk/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sk/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sk/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sk/google-cloud-sdk/completion.zsh.inc'; fi
