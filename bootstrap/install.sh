#!/bin/bash

set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

BOLD="$(tput bold 2>/dev/null || printf "")"
RED="$(tput setaf 1 2>/dev/null || printf "")"
GREEN="$(tput setaf 2 2>/dev/null || printf "")"
NO_COLOUR="$(tput sgr0 2>/dev/null || printf "")"

function info() {
    printf '%s\n' "${BOLD}${GREEN} :: $*${NO_COLOUR}"
}

function error() {
    printf '%s\n' "${BOLD}${RED} :: $*${NO_COLOUR}"
}

# Install packages
function main() {
    install-common-utils
    install-starship
    install-neovim
    install-rust
    install-deno
    install-ripgrep
    install-bat
    install-zoxide
    install-espanso
    install-wezterm
    install-gui-applications
}

function install-common-utils() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install git curl wget zsh unzip tig
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y upgrade
        sudo dnf -y install git curl wget zsh unzip tig xclip
    fi
}

function install-atuin() {
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

function install-starship() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install starship
    else
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    fi
}

function install-neovim() {
    if [[ "$(uname)" == "Darwin" ]]; then
        # If failed to install Neovim, see https://github.com/neovim/neovim/issues/16217#issuecomment-959793388
        brew install --HEAD neovim
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install neovim
    fi
}

function install-rust() {
    curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    sudo dnf -y install rust-libudev-devel rust-x11+xtst-devel
}

function install-deno() {
    curl -fsSL https://deno.land/install.sh | sh
}

function install-ripgrep() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install ripgrep
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install ripgrep
    fi
}

function install-bat() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install bat
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install bat
    fi
}

function install-zoxide() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install zoxide
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install zoxide fzf
    fi
}

function install-espanso() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew tap espanso/espanso
        brew install espanso
    else
        info "Manual install needed for espanso."
    fi
}

function install-ghostty() {
    if [[ -x "$(command -v dnf)" ]]; then
        sudo dnf copr enable pgdev/ghostty
        sudo dnf install ghostty
    fi
}

function install-gui-applications() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install --cask \
            firefox \
            google-japanese-ime \
            karabiner-elements \
            keyboardcleantool \
            spotify \
            wireshark
    elif [[ -x "$(command -v dnf)" ]] && [[ -n "$DESKTOP_SESSION" ]]; then
        # TODO: LinuxでインストールしているGUIアプリのインストール行を書く
        info "Install GUI applications if you need."
    fi
}

main
info "Finished setup!"
info 'To update default shell, run: chsh -s $(which zsh)'
