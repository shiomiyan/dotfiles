#!/bin/bash

set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

BOLD="$(tput bold 2>/dev/null || printf "")"
UNDERLINE="$(tput smul 2>/dev/null || printf "")"
RED="$(tput setaf 1 2>/dev/null || printf "")"
GREEN="$(tput setaf 2 2>/dev/null || printf "")"
YELLOW="$(tput setaf 3 2>/dev/null || printf "")"
BLUE="$(tput setaf 4 2>/dev/null || printf "")"
MAGENTA="$(tput setaf 5 2>/dev/null || printf "")"
NO_COLOUR="$(tput sgr0 2>/dev/null || printf "")"

function info() {
    printf '%s\n' "${BOLD}${MAGENTA} :: $*${NO_COLOUR}"
}

function error() {
    printf '%s\n' "${BOLD}${RED} :: $*${NO_COLOUR}"
}

DOTFILES_INSTALLER_TMP="$HOME/.dotfiles_installer_tmp"

# Install packages
function main() {
    mkdir -p $DOTFILES_INSTALLER_TMP
    mkdir -p ~/.config/

    setup-common-utils
    setup-starship
    setup-neovim
    setup-rust
    setup-deno
    setup-nodejs
    setup-ripgrep
    setup-bat
    setup-zoxide
    setup-espanso
}

function setup-common-utils() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install git curl wget zsh unzip tig
    elif [ -x "$(command -v apt)" ]; then
        sudo apt update
        sudo apt -y upgrade
        sudo apt -y install git curl wget zsh unzip tig build-essential ca-certificates gnupg
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y upgrade
        sudo dnf -y install git curl wget zsh unzip tig
    else
        error 'Unsupported operating system.'
    fi

    git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles
    ln -sf ~/dotfiles/.zshenv ~
    ln -sf ~/dotfiles/config/zsh ~/.config/zsh
    ln -sf ~/dotfiles/config/git ~/.config/git
    ln -sf ~/dotfiles/config/tig ~/.config/tig
}

function setup-starship() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install starship
    else
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    fi

    ln -sf ~/dotfiles/config/starship.toml ~/.config/starship.toml
}

function setup-neovim() {
    if [ "$(uname)" == "Darwin" ]; then
        # If failed to install Neovim, see https://github.com/neovim/neovim/issues/16217#issuecomment-959793388
        brew install --HEAD neovim
    else
        # ref: https://github.com/neovim/neovim/wiki/Installing-Neovim#appimage-universal-linux-package
        pushd $DOTFILES_INSTALLER_TMP
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract
        sudo mv squashfs-root /
        sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
        popd
    fi

    ln -sf ~/dotfiles/config/nvim ~/.config/nvim
}

function setup-rust() {
    curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

function setup-deno() {
    curl -fsSL https://deno.land/install.sh | sh
}

function setup-nodejs() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install node
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y install nodejs
    elif [ -x "$(command -v apt)" ]; then
        # Install NodeJS. ref: https://github.com/nodesource/distributions
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        NODE_MAJOR=20
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        sudo apt update && sudo apt -y install nodejs
    fi
}

function setup-ripgrep() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install ripgrep
    elif [ -x "$(command -v apt)" ]; then
        pushd $DOTFILES_INSTALLER_TMP
        curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        sudo dpkg -i ripgrep_13.0.0_amd64.deb
        popd
    fi
}

function setup-bat() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install bat
    elif [ -x "$(command -v apt)" ]; then
        pushd $DOTFILES_INSTALLER_TMP
        curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb
        sudo dpkg -i bat-musl_0.24.0_amd64.deb
        popd
    fi
}

function setup-zoxide() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install zoxide
    else
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
}

function setup-espanso() {
    if [ "$(uname)" == "Darwin" ]; then
        brew tap espanso/espanso
        brew install espanso
    elif [ -x "$(command -v apt)" ]; then
        pushd $DOTFILES_INSTALLER_TMP
        wget https://github.com/federico-terzi/espanso/releases/download/v2.1.8/espanso-debian-x11-amd64.deb
        sudo apt install ./espanso-debian-x11-amd64.deb
        espanso service register
        espanso start
        popd
    fi

    ln -sf ~/dotfiles/config/espanso ~/.config/espanso
}

function setup-wezterm() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install --cask wezterm
    elif [ -x "$(command -v apt)" ]; then
        pushd $DOTFILES_INSTALLER_TMP
        curl -LO https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly.Debian12.deb
        sudo apt install -y wezterm-nightly.Debian12.deb
        popd
    fi

    ln -sf ~/dotfiles/config/wezterm ~/.config/wezterm
}

function setup-gui-applications() {
    if [ "$(uname)" == "Darwin" ]; then
        brew tap wez/wezterm
        brew install --cask \
            alacritty \
            firefox \
            google-japanese-ime \
            karabiner-elements \
            keyboardcleantool \
            spotify \
            wireshark
        brew install wez/wezterm/wezterm-nightly
    fi

    # TODO: LinuxでGUIアプリをインストールするコマンドを書く
}

main
info "Finished setup!"
info "To update default shell, run command below:\nsudo usermod -s \`which zsh\` \$USER"
