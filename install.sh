#!/bin/sh

# required softwares
case "$OSTYPE" in
    darwin*)
        brew install vim git zsh curl tmux
    ;;
    linux*)
        apt update
        apt upgrade
        apt install vim git zsh curl tmux
    ;;
esac

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/shiomiyan/.dotfiles.git "$HOME/.dotfiles"
fi

# unlink existing symlinks
unlink ~/.vimrc
unlink ~/.vim
unlink ~/.zshrc
unlink ~/.zsh
unlink ~/.tmux.conf

# delete existing dotfiles
rm -f ~/.vmirc
rm -rf ~/.vim
rm -f ~/.zshrc
rm -rf ~/.zsh
rm -f ~/.tmux.conf

# symlinks
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.vim ~/.vim
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.zsh ~/.zsh
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# vim
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -e -s +VimEnter +PlugInstall +qall
