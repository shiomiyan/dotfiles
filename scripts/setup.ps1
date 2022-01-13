Set-ExecutionPolicy Bypass -Force

# download win32yank
Invoke-WebRequest `
    -Uri "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip" `
    -OutFile C:\win32yank.zip

# unzip win32yank and remove tmp file
Expand-Archive C:\win32yank.zip -DestinationPath C:\Tools\win32yank
Remove-Item C:\win32yank.zip

# install chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# always yes
choco feature enable -n allowGlobalConfirmation

# install tools using choco
cinst alacritty neovim git nodejs-lts

# reload env vars
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
                + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

# clone repo
git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles
