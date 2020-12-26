#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone --depth=1 https://github.com/.dotfiles/dotfiles.git "$HOME/.dotfiles" --recursive
    cd "$HOME/.dotfiles"
fi

# delete existing dotfiles
rm -f ~/.vmirc
rm -f ~/.zshrc
rm -f ~/.zprofile
rm -f ~/.zshenv
rm -f ~/.tmux.conf
rm -f ~/.tmux
rm -f ~/.gitignore_global
rm -f ~/.yabairc
rm -rf ~/.vim
rm -rf ~/.config

# symlinks
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.zinit ~/.zinit
ln -sf ~/.dotfiles/.zsh ~/.zshrc
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/.config ~/.config
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/.tmux ~/.tmux
ln -sf ~/.dotfiles/.gitignore_global ~/.gitginore_global
ln -sf ~/.dotfiles/.vim ~/.vim
ln -sf ~/.dotfiles/.yabairc ~/.yabairc

# install vim-plug
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install Vim plugins
vim +silent +VimEnter +PlugInstall +qall
