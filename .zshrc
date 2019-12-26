export LANG=ja_JP.UTF-8
PROMPT='%F{6}%c%f $ '

# enable input candidates
autoload -Uz compinit
compinit

# add color selected input candidates
zstyle ':completion:*' menu select

# Do not keep the same command history
setopt HIST_IGNORE_DUPS

# zsh pure prompt theme enable -> clear "#" bottom two lines
# autoload -U promptinit; promptinit
# prompt pure

# Added by Zplugin's installer
source '/Users/sk/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
# End of Zplugin's installer chunk

# add Zplugin's
zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-syntax-highlighting

# config starship
eval "$(starship init zsh)"

# alias
alias cdd="cd ~/dev"
alias pbc="pbcopy"
alias jl="jupyter lab"
alias v="vim"
alias g="git"
alias exa="exa --group-directories-first"
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
test -r /Users/sk/.opam/opam-init/init.zsh && . /Users/sk/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


# cargo path
export PATH="$HOME/.cargo/bin:$PATH"

# binutils
export PATH="/usr/local/opt/binutils/bin:$PATH"

# laravel path setting
export PATH="/Users/sk/.composer/vendor/bin:$PATH"

# Open MPI: Version 2.0.4 path configuration
export PATH="$HOME/opt/usr/local/bin/:$PATH"

# AWS CLI configuration
export PATH="/Users/sk/.local/bin:$PATH"

# cloud_sql_proxy (GCP)
export PATH="/Users/sk/:$PATH"

# auto start tmux
if [ $SHLVL = 1 ]; then
  tmux
fi

# llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sk/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sk/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sk/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sk/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# pyenv setting
unalias pyenv 2>/dev/null
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
alias pyenv="SDKROOT=$(xcrun --show-sdk-path) pyenv"

#rbenv
eval "$(rbenv init -)"
