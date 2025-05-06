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
    install-atuin
    install-starship
    install-neovim
    install-rust
    install-deno
    install-ripgrep
    install-bat
    install-zoxide
    install-espanso
    install-gui-applications
}

function install-common-utils() {
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install git curl wget zsh unzip tig
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y upgrade
        sudo dnf -y install git curl wget zsh unzip tig xclip
        sudo dnf -y group install development-tools

        # change default shell to zsh
        if [[ "$(echo $SHELL)" != "zsh" ]]; then
            chsh -s $(which zsh)
        fi
    fi
}

function install-atuin() {
    [[ -x "$(command -v atuin)" ]] && info "atuin already installed" && return

    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

function install-starship() {
    [[ -x "$(command -v starship)" ]] && info "starship already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        brew install starship
    else
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    fi
}

function install-neovim() {
    [[ -x "$(command -v nvim)" ]] && info "neovim already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        # If failed to install Neovim, see https://github.com/neovim/neovim/issues/16217#issuecomment-959793388
        brew install --HEAD neovim
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install neovim
    fi
}

function install-rust() {
    [[ -x "$(command -v cargo)" ]] && info "rust toolchains already installed" && return

    curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    sudo dnf -y install rust-libudev-devel rust-x11+xtst-devel
}

function install-deno() {
    [[ -x "$(command -v deno)" ]] && info "deno already installed" && return

    curl -fsSL https://deno.land/install.sh | sh -s -- -y
}

function install-ripgrep() {
    [[ -x "$(command -v rg)" ]] && info "ripgrep already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        brew install ripgrep
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install ripgrep
    fi
}

function install-bat() {
    [[ -x "$(command -v bat)" ]] && info "bat already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        brew install bat
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install bat
    fi
}

function install-zoxide() {
    [[ -x "$(command -v zoxide)" ]] && info "zoxide already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        brew install zoxide
    elif [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install zoxide fzf
    fi
}

function install-espanso() {
    [[ -x "$(command -v espanso)" ]] && info "espanso already installed" && return

    if [[ "$(uname)" == "Darwin" ]]; then
        brew tap espanso/espanso
        brew install espanso
    else
        info "Manual install needed for espanso."
    fi
}

function install-gui-ghostty() {
    [[ -x "$(command -v ghostty)" ]] && info "ghostty already installed" && return

    if [[ -x "$(command -v dnf)" ]]; then
        sudo dnf copr enable pgdev/ghostty
        sudo dnf install ghostty
    fi
}

function install-gui-ime() {
    if [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y install fcitx5 fcitx5-mozc
    fi
}

function install-gui-evremap() {
    if [[ -x "$(command -v dnf)" ]]; then
        sudo dnf -y group install development-tools
        sudo dnf -y install libevdev-devel

        TMP=$(mktemp -d)
        git clone --depth=1 https://github.com/wez/evremap.git "$TMP"

        pushd $TMP
        cargo build --release
        sudo cp target/release/evremap /usr/bin/evremap
        popd
    fi
}

function install-flatpak-apps() {
    if [[ -x "$(command -v flatpak)" ]]; then
        sudo flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

        flatpak install -y flathub com.bitwarden.desktop
        flatpak install -y flathub com.discordapp.Discord
        flatpak install -y flathub com.github.maoschanz.drawing
        flatpak install -y flathub com.github.tchx84.Flatseal
        flatpak install -y flathub com.slack.Slack
        flatpak install -y flathub com.spotify.Client
        flatpak install -y flathub io.podman_desktop.PodmanDesktop
        flatpak install -y flathub org.localsend.localsend_app

        if [[ "$(echo $DESKTOP_SESSION)" == "gnome" ]]; then
            flatpak install -y org.gnome.Extensions
        fi
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
        install-gui-ghostty
        install-gui-ime
        install-gui-evremap
        install-flatpak-apps
    fi
}

main
info "Finished setup!"
info 'To update default shell, run: chsh -s $(which zsh)'
