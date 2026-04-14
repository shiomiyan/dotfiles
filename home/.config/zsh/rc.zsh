export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

export PATH="$HOME/.local/bin:$PATH"

typeset -U path PATH

autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b) '

setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%# '

[[ -d "$HOME/.atuin" ]] && export PATH="$HOME/.atuin/bin:$PATH"

export GPG_TTY=$(tty)

if [[ -x "$(command -v docker)" ]]; then
    function docker-horobi() {
        docker compose down --rmi all --volumes --remove-orphans
        docker stop $(docker ps -q) && docker system prune --volumes
    }
fi

if [[ -x "$(command -v xclip)" ]]; then
    alias clip="xclip -sel clip"
fi

if [[ -x "$(command -v xdg-open)" ]]; then
    alias open="xdg-open"
fi

if [[ $(uname) == "Darwin" ]]; then
    alias clip="pbcopy"
    alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

if [[ "$(uname -r)" =~ 'microsoft' ]]; then
    source "$ZDOTDIR/wsl.zsh"
fi

export LESSHISTFILE="$XDG_STATE_HOME"/less/history

[[ -d "$HOME/.cargo" ]] && export PATH="$HOME/.cargo/bin:$PATH"

[[ -d "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"
[[ -d "$HOME/go/bin" ]] && export PATH="$PATH:$HOME/go/bin"

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

if [[ -x "$(command -v npm)" ]]; then
    export PATH="$PATH:$HOME/.npm/bin"
    eval "$(npm completion)"
fi

if [[ -x "$(command -v pnpm)" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    alias pp="pnpm"
fi

if [[ -x "$(command -v opam)" ]]; then
    [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
fi

[[ -d "/usr/local/opt/llvm/bin" ]] && export PATH="/usr/local/opt/llvm/bin:$PATH"

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh" || touch "$ZDOTDIR/local.zsh"

if [[ -x "$(command -v mise)" ]]; then
    eval "$(mise activate zsh --shims)"
fi

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -s "/home/sk736b/.bun/_bun" ] && source "/home/sk736b/.bun/_bun"
