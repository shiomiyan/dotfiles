# clone repo
git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles

# create symlinks for dotfiles
New-Item -ItemType SymbolicLink `
    -Path   $env:appdata\alacritty\alacritty.yml `
    -Target $env:HOMEPATH\dotfiles\windows\alacritty.yml

git config --global core.editor 'nvim'
