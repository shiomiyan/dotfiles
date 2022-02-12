#!/bin/bash

set -ue

# install packages
case "$OSTYPE" in
    "darwin"*)
        brew install            \
            vim                 \
            git                 \
            zsh                 \
            curl                \
            tmux                \
            starship
        brew install --cask     \
            alacritty           \
            firefox             \
            google-japanese-ime \
            karabiner-elements  \
            keyboardcleantool   \
            rectangle           \
            spotify
    ;;
    "linux"*)
        if [ -e /etc/fedora-release ]; then
            sudo dnf upgrade
            sudo dnf install -y \
                neovim          \
                git             \
                zsh             \
                curl            \
                wget            \
                unzip           \
                tmux            \
                gcc             \
                nodejs          \
                openssl-devel
        else
            echo "Unsupported distribution."
            exit 1
        fi

        # install starship
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

        # install Rust
        curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # rust-analyzer
        # https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
    ;;
    *)
        echo "Could not identify the OS."
        exit 1
    ;;
esac

# clone dotfiles repo
git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles

# create symlinks
ln -sf ~/dotfiles/.zshrc     ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tigrc     ~/.tigrc
ln -sf ~/dotfiles/.config    ~/.config

if ! command -v wslpath &> /dev/null ; then
    # win32yank for Vim or Neovim
    if [ ! -e /usr/local/bin/win32yank.exe ]; then
        curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
        unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
        chmod +x /tmp/win32yank.exe
        sudo mv /tmp/win32yank.exe /usr/local/bin/
    fi
fi

# vim-plug installation for Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

sudo usermod -s `which zsh` $USER
