# allow script execution
Set-ExecutionPolicy Bypass -Force

function Install-Apps {
<#

.DESCRIPTION
    function for install require applications and dependencies
    NOTE: you need to install winget manually

#>

    # install winget
    Invoke-WebRequest `
    -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" `
    -OutFile "C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Import-Module Appx -UseWindowsPowerShell
    Add-AppxPackage C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

    # install applications from winget
    winget import -i "$HOME\dotfiles\install_scripts\winget.json"


    # install chocolatey
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # always enable -y option
    choco feature enable -n allowGlobalConfirmation

    # install applications using choco
    cinst neovim deno zig hugo-extended ripgrep starship

    # Install Neovim vim-plug
    Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        New-Item "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

    # install Rust
    Invoke-WebRequest `
        -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
        -OutFile C:\rustup-init.exe
    C:\rustup-init.exe -y
    Remove-Item -Force C:\rustup-init.exe

}

function Connect-Dotfiles {

<#

.DESCRIPTION
    function that craete symbolic links

#>

    # clone repo if not exists
    if ((Test-Path "$HOME\dotfiles") -ne "True") {
        git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles
    }

    New-Item -ItemType SymbolicLink `
        -Path   $PROFILE `
        -Target $HOME\dotfiles\windows\Microsoft.PowerShell_profile.ps1

    New-Item -ItemType SymbolicLink `
        -Path   $env:HOMEPATH\.config\wezterm\wezterm.lua `
        -Target $env:HOMEPATH\dotfiles\.config\wezterm\wezterm.lua

    New-Item -ItemType SymbolicLink `
        -Path   $env:LOCALAPPDATA\nvim `
        -Target $env:HOMEPATH\dotfiles\.config\nvim\

    git config --global core.editor 'nvim'

}


# Install Applications and Dependencies.
if ($(Read-Host "Proceed application and dependencies installation [y/n]") -eq "y") {
    Write-Output "Confirmed."
    Install-Apps
} else {
    Write-Output "Setup cancelled."
}

# Setup Application Config.
if ($(Read-Host "Proceed application and dependencies installation [y/n]") -eq "y") {
    Write-Output "Confirmed."
    Connect-Dotfiles
} else {
    Write-Output "Setup cancelled."
}