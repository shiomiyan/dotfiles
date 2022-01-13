# install Rust
Invoke-WebRequest "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
  -OutFile C:\rustup-init.exe
C:\rustup-init.exe -y

Remove-Item -Force C:\rustup-init.exe

# starship
echo "Invoke-Expression (&starship init powershell)" >> $profile

# create symlinks for dotfiles
cmd.exe /c mklink %userprofile%\_vimrc %userprofile%\dotfiles\src\.vimrc
# cmd.exe /c mklink %userprofile%\.config\starship.toml %userprofile%\dotfiles\src\.config\starship.toml
cmd.exe /c mklink %localappdata%\nvim\init.vim %localappdata%\dotfiles\src\.config\nvim\init.vim

# install vim-plug and install plugins
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

# vim -es -u _vimrc -i NONE -c "PlugInstall" -c "qa"
