export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Load home-manager session variables
# https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone
[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
