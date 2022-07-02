# allow script execution
Set-ExecutionPolicy Bypass -Force

function Install-Apps {
<#

.DESCRIPTION
    function for install require applications and dependencies
    NOTE: you need to install winget manually

#>

    # install winget if not exists
    if (-not (Get-Command winget -ea SilentlyContinue)) {
        # install dependencies for winget
        Invoke-WebRequest `
            -Uri "https://globalcdn.nuget.org/packages/microsoft.ui.xaml.2.7.1.nupkg" `
            -OutFile "C:\Windows\Temp\microsoft.ui.xaml.2.7.1.zip"
        Expand-Archive `
            -Path "C:\Windows\Temp\microsoft.ui.xaml.2.7.1.zip" `
            -DestinationPath "C:\Windows\Temp\microsoft.ui.xaml.2.7.1"
        Add-AppxPackage "C:\Windows\Temp\microsoft.ui.xaml.2.7.1\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"

        Invoke-WebRequest `
            -Uri "https://download.microsoft.com/download/4/7/c/47c6134b-d61f-4024-83bd-b9c9ea951c25/14.0.30035.0-Desktop/Microsoft.VCLibs.x64.14.00.Desktop.appx" `
            -OutFile "C:\Windows\Temp\vclibs.appx"
        Add-AppPackage "C:\Windows\Temp\vclibs.appx"

        Install-Module PowershellGet -Force

        Invoke-WebRequest `
            -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" `
            -OutFile "C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Import-Module Appx -UseWindowsPowerShell
        Add-AppxPackage C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    }

    # install chocolatey if not exists
    if (-not (Get-Command choco -ea SilentlyContinue)) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # install git
    winget install git.git

    # refresh environment value
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    refreshenv

    # clone repo if not exists
    if ((Test-Path "$HOME\dotfiles") -ne "True") {
        git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles
    }

    # install applications from winget
    winget import -i "$HOME\dotfiles\install_scripts\winget.json"

    # always enable -y option
    choco feature enable -n allowGlobalConfirmation

    # install applications using choco
    choco install     `
        neovim        `
        deno          `
        zig           `
        hugo-extended `
        ripgrep       `
        starship

    # Install Neovim vim-plug
    Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
        New-Item "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

    # install Rust
    Invoke-WebRequest `
        -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
        -OutFile C:\rustup-init.exe
    C:\rustup-init.exe -y
    Remove-Item -Force C:\rustup-init.exe

    refreshenv

}

function Connect-Dotfiles {

<#

.DESCRIPTION
    function that craete symbolic links

#>

    New-Item -ItemType Directory -Path $HOME\Documents\PowerShell
    New-Item -ItemType SymbolicLink `
        -Path   $PROFILE `
        -Target $HOME\dotfiles\windows\Microsoft.PowerShell_profile.ps1

    New-Item -ItemType SymbolicLink `
        -Path   $HOME\.config `
        -Target $HOME\dotfiles\.config\

    New-Item -ItemType SymbolicLink `
        -Path   $env:LOCALAPPDATA\nvim `
        -Target $HOME\dotfiles\.config\nvim\

    git config --global core.editor 'nvim'

    # Install Neovim plugins
    nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

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
