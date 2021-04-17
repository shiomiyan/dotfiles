#!/bin/sh

# required softwares
case "$OSTYPE" in
    "darwin"*)
        echo "run on macos"
        brew install vim git zsh curl tmux starship
    ;;
    "linux"*)
        echo "run on linux"
        sudo apt update
        sudo apt upgrade
        sudo apt install vim git zsh curl tmux
        sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    ;;
    *)
        echo "can not detect the ostype"
    ;;
esac

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/shiomiyan/.dotfiles.git "$HOME/.dotfiles"
fi

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
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.vim ~/.vim
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/.config ~/.config

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# vim
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +'PlugInstall --sync' +qa
