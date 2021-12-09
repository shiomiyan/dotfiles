Set-ExecutionPolicy Bypass -Force

# install chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

# install tools using choco
cinst vim git fnm starship

# install Rust
Invoke-WebRequest "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
  -OutFile C:\rustup-init.exe
C:\rustup-init.exe -y

Remove-Item -Force C:\rustup-init.exe

# reload env vars
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
  + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

# clone repo
git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles

# === setup tools ===

# starship
echo "Invoke-Expression (&starship init powershell)" >> $profile

# setting up fnm and node
# プロファイル再読み込みでエラーを吐くのでここでは一時的に読み込ませる
fnm env --use-on-cd | Out-String | Invoke-Expression > $null
echo "fnm env --use-on-cd | Out-String | Invoke-Expression" >> $profile *> $null
fnm install v16.13.0
fnm use v16.13.0

# create symlinks for dotfiles
cmd.exe /c mklink %userprofile%\_vimrc %userprofile%\dotfiles\src\.vimrc
cmd.exe /c mklink %userprofile%\.tigrc %userprofile%\dotfiles\src\.tigrc
cmd.exe /c mklink %userprofile%\.config\starship.toml %userprofile%\dotfiles\src\.config\starship.toml
cmd.exe /c mklink /D %userprofile%.\vimfiles %userprofile%\dotfiles\src\.vim

# install vim-plug and install plugins
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

vim -es -u _vimrc -i NONE -c "PlugInstall" -c "qa"
