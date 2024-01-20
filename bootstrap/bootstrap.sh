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
    setup-ripgrep
    setup-bat
    setup-zoxide
    setup-espanso
    setup-wezterm
    setup-gui-applications
}

function setup-common-utils() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install git curl wget zsh unzip tig
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y upgrade
        sudo dnf -y install git curl wget zsh unzip tig xclip
    else
        error 'Unsupported operating system.'
    fi

    git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles
    ln -sf ~/dotfiles/zshenv ~/.zshenv
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

function setup-ripgrep() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install ripgrep
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y install ripgrep
    fi
}

function setup-bat() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install bat
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y install bat
    fi
}

function setup-zoxide() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install zoxide
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y install zoxide fzf
    fi
}

function setup-espanso() {
    if [ "$(uname)" == "Darwin" ]; then
        brew tap espanso/espanso
        brew install espanso
    else
        info "Manual install needed."
    fi

    ln -sf ~/dotfiles/config/espanso ~/.config/espanso
}

function setup-wezterm() {
    if [ "$(uname)" == "Darwin" ]; then
        brew tap wez/wezterm
        brew install --cask wezterm
    elif [ -x "$(command -v dnf)" ] && [ -n "$DESKTOP_SESSION" ]; then
        sudo dnf copr enable wezfurlong/wezterm-nightly
        sudo dnf install wezterm
    fi

    ln -sf ~/dotfiles/config/wezterm ~/.config/wezterm
}

function setup-gui-applications() {
    if [ "$(uname)" == "Darwin" ]; then
        brew install --cask \
            firefox \
            google-japanese-ime \
            karabiner-elements \
            keyboardcleantool \
            spotify \
            wireshark
    elif [ -x "$(command -v dnf)" ] && [ -n "$DESKTOP_SESSION" ]; then
        # TODO: LinuxでインストールしているGUIアプリのインストール行を書く
    fi
}

main
info "Finished setup!"
info "To update default shell, run command below:\nsudo usermod -s \`which zsh\` \$USER"
