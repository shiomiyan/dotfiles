# clone repo
git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles

# create symlinks for dotfiles
cmd.exe /c mklink %appdata%\alacritty\alacritty.yml %userprofile%\dotfiles\windows\alacritty.yml

git config --global core.editor 'nvim'