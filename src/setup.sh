#!/bin/bash

# install tools
case "$OSTYPE" in
    "darwin"*)
        echo "run on macos"
        brew install vim git zsh curl tmux starship
    ;;
    "linux"*)
        echo "run on linux"
        apt update -y
        apt install vim git zsh curl tmux -y
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    ;;
    *)
        echo "can not detect the OSTYPE"
    ;;
esac

echo -e "\e[32m tool install complete \e[m"

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
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.config ~/.config

# install vim-plug and plugins
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"

chsh -s `/usr/bin/zsh`
exec $SHELL
