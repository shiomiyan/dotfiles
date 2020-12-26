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

# Added by Zplugin's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# add Zplugin's
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# config starship
eval "$(starship init zsh)"

#=======================================================#
# profiling zsh bottle necks
#if (which zprof > /dev/null 2>&1) ;then
#    zprof
#fi
#=======================================================#

source ~/.zsh/aliases.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/tmux.zsh
