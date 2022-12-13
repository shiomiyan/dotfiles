#!/bin/bash

set -o nounset # error when referencing undefined variable
set -o errexit # exit when command fails

# Install packages
function main() {
    case $OSTYPE in
    linux*)
        if [ -x "$(command -v dnf)" ]; then
            # Install packages from dnf
            dnf_install
        else
            error "Command dnf not found. Unsupported distribution."
            exit 1
        fi

        # Build and Install Neovim from source
        git clone https://github.com/neovim/neovim /tmp/neovim && cd /tmp/neovim
        make CMAKE_BUILD_TYPE=Release
        sudo make install
        cd ~

        # Install starship
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

        # Install Rust
        curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Install Deno (Mainly used for Neovim plugins)
        curl -fsSL https://deno.land/install.sh | sh
        ;;

    darwin*)
        brew_install
        ;;

    *)
        error "Unsupported platform."
        exit 1
        ;;

    esac

    info "Finished package installation."

    # Clone dotfiles repo and create symlinks
    git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles
    create_symlinks
    info "Symlinks to dotfiles has been created."

    # Install Neovim Plugins
    nvim -es -u ~/.config/nvim/init.lua -i NONE -c "PlugInstall" -c "qa"
}

function dnf_install() {
    # Upgrade current packages
    sudo dnf -y upgrade

    # Install toolchains
    sudo dnf -y install \
        bat \
        fd-find \
        gh \
        git \
        zsh \
        wget \
        unzip \
        tmux \
        nodejs \
        openssl-devel \
        ripgrep \
        zoxide

    # Neovim build dependencies
    sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl

    # Setup GUI applications if desktop display server exists
    if command -v Xorg >/dev/null; then
        # Setup Nvidia driver
        sudo dnf install \
            "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
            "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
        sudo dnf install akmod-nvidia

        sudo dnf install \
            fcitx5 fcitx5-mozc fcitx5-lua \
            xclip

        # Desktop applications
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y \
            com.bitwarden.desktop \
            com.discordapp.Discord \
            com.spotify.Client
    fi
}

function brew_install() {
    brew tap delphinus/sfmono-square
    brew install \
        bat \
        gh \
        git \
        zsh \
        curl \
        tmux \
        tig \
        starship \
        exa \
        ripgrep \
        zoxide \
        sfmono-square
    # If failed to install Neovim, see https://github.com/neovim/neovim/issues/16217#issuecomment-959793388
    brew install --HEAD neovim

    # Install GUI applications
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
}

function create_symlinks() {
    mkdir -p /tmp/dot_backup
    [ -f ~/.zshrc ] && mv ~/.zshrc /tmp/dot_backup/
    [ -f ~/.zshenv ] && mv ~/.zshenv /tmp/dot_backup/
    # [ -f ~/.tmux.conf ] && mv ~/.tmux.conf /tmp/dot_backup/
    [ -d ~/.config ] && mv ~/.config /tmp/dot_backup/

    ln -sf ~/dotfiles/.zshenv ~
    ln -sf ~/dotfiles/.tmux.conf ~
    ln -sf ~/dotfiles/.config ~

    # 退避させた`.config`配下のファイルおよびディレクトリを戻す
    cp -r -n /tmp/dot_backup/.config/* ~/.config/
}

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

info "Start Installation."

# Start installation
main

info "Setup succeed."
info "To update default shell, run: sudo usermod -s \`which zsh\` \$USER"
