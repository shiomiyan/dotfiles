#!/bin/bash

# install tools
case "$OSTYPE" in
    "darwin"*)
        echo "run on macos"
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
        if [ -e /etc/arch-release ]; then
            sudo pacman -Syyu --noconfirm
            sudo pacman -S neovim git zsh curl tmux gcc --noconfirm
        elif [ -e /etc/fedora-release ]; then
            sudo dnf install -y neovim git zsh curl tmux gcc
        else
            echo "run on linux"
            sudo apt update -y
            sudo apt install vim git zsh curl tmux -y
        fi

        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
        # install Rust
        curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    ;;
    *)
        echo "can not detect the OSTYPE"
    ;;
esac

git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles

# symlinks
ln -sf ~/dotfiles/src/.zshrc       ~/.zshrc
ln -sf ~/dotfiles/src/.tmux.conf   ~/.tmux.conf
ln -sf ~/dotfiles/src/.tigrc       ~/.tigrc
# ln -sf ~/dotfiles/src/.vimrc                ~/.vimrc
# ln -sf ~/dotfiles/src/.vim                  ~/.vim
ln -sf ~/dotfiles/src/.config/nvim/ ~/.config/nvim

# === VIM SETUP ===
# mkdir -p ~/.vim/autoload
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vim-plug installation for Neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"
nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

sudo usermod -s `which zsh` $USER
