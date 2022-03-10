# clone repo
git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles

# create symlinks for dotfiles
New-Item -ItemType SymbolicLink `
    -Path   $env:appdata\alacritty\alacritty.yml `
    -Target $env:HOMEPATH\dotfiles\windows\alacritty.yml

New-Item -ItemType SymbolicLink `
    -Path   $env:HOMEPATH\.config\wezterm\wezterm.lua `
    -Target $env:HOMEPATH\dotfiles\.config\wezterm\wezterm.lua

New-Item -ItemType SymbolicLink `
    -Path   $env:LOCALAPPDATA\nvim `
    -Target $env:HOMEPATH\dotfiles\.config\nvim\

git config --global core.editor 'nvim'
