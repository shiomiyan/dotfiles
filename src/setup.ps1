# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
cinst vim git

# install node for coc-vim
## install node version manager
cinst fnm
Write-Output "fnm env --use-on-cd | Out-String | Invoke-Expression" | Out-File -Encoding default -Append $profile
& $profile
fnm install v16.13.0
fnm use v16.13.0

# setting up Vim
cmd.exe /c mklink _vimrc %userprofile%\.dotfiles\.vimrc
cmd.exe /c mklink /D .\vimfiles %userprofile%\.dotfiles\.vim

# install vim-plug and install plugins
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"
