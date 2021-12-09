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
            pacman -Syyu --noconfirm
	    pacman -S gvim git zsh curl tmux --noconfirm
	else
	    echo "run on linux"
            apt update -y
            apt install vim git zsh curl tmux -y
	fi
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
        curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y # install Rust
    ;;
    *)
        echo "can not detect the OSTYPE"
    ;;
esac

git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles

# unlink existing symlinks
unlink ~/.vimrc
unlink ~/.vim
unlink ~/.zshrc
unlink ~/.tmux.conf
unlink ~/.config

# delete existing dotfiles
rm -f ~/.vmirc
rm -rf ~/.vim
rm -f ~/.zshrc
rm -f ~/.tmux.conf
rm -rf ~/.config

# symlinks
ln -sf ~/dotfiles/src/.vimrc ~/.vimrc
ln -sf ~/dotfiles/src/.vim ~/.vim
ln -sf ~/dotfiles/src/.zshrc ~/.zshrc
ln -sf ~/dotfiles/src/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/src/.config ~/.config

# install vim-plug and plugins
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"

chsh -s $(which zsh) && exec $SHELL
