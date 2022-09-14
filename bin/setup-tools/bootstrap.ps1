[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Allow script execution
Set-ExecutionPolicy Bypass -Force

function local:Install-App {
    <#

.DESCRIPTION
    Function for install require applications and dependencies

#>

    # Install winget if not exists
    if (-not (Get-Command winget -ea SilentlyContinue)) {
        # install dependencies for winget
        $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Invoke-WebRequest -Uri $wingetUrl -OutFile "C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Import-Module Appx -UseWindowsPowerShell
        try {
            Add-AppxPackage C:\Windows\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        } catch {
            Write-Output "Failed to install winget. Try install manually." $wingetUrl
        }
    }

    # Install chocolatey if not exists
    if (-not (Get-Command choco -ea SilentlyContinue)) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Install scoop if not exists
    if (-not (Get-Command scoop -ea SilentlyContinue)) {
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    }

    # Install git first
    scoop install git

    # Refresh environment value
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    refreshenv

    # Clone repo if not exists
    if (!(Test-Path "$HOME\dotfiles")) {
        git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles
    }

    # GUI applications are installed by winget
    winget import -i "$HOME\dotfiles\install_scripts\winget.json"

    # Add scoop buckets
    scoop bucket add extras
    scoop bucket add versions

    # Install runtimes, commandline tools
    scoop install     `
        make          `
        git           `
        gh            `
        ghq           `
        peco          `
        sudo          `
        deno          `
        nodejs-lts    `
        starship      `
        bat           `
        lsd           `
        zoxide        `
        fd            `
        ripgrep       `
        rga           `
        hugo-extended `

    # Always enable -y option
    choco feature enable -n allowGlobalConfirmation

    # Install applications using choco
    choco install neovim --pre
    choco install espanso --pre


    # Install Rust
    Invoke-WebRequest `
        -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
        -OutFile C:\rustup-init.exe
    C:\rustup-init.exe -y
    Remove-Item -Force C:\rustup-init.exe

    refreshenv

}

function local:Create-Symlink {

    <#

.DESCRIPTION
    Function that craete symbolic links

#>

    New-Item -ItemType SymbolicLink `
        -Path   $HOME\Documents\PowerShell `
        -Target $HOME\dotfiles\.config\powershell

    New-Item -ItemType SymbolicLink `
        -Path   $HOME\.config `
        -Target $HOME\dotfiles\.config\

    New-Item -ItemType SymbolicLink `
        -Path   $env:LOCALAPPDATA\nvim `
        -Target $HOME\dotfiles\.config\nvim\

    New-item -ItemType SymbolicLink `
        -Path   $env:APPDATA\espanso `
        -Target $HOME\dotfiles\.config\espanso

    git config --global core.editor 'nvim'

    # Install Neovim plugins
    nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

}


# Install Applications and Dependencies.
if ($(Read-Host "Proceed application and dependencies installation [y/n]") -eq "y") {
    Write-Output "Confirmed."
    Install-Apps
}
else {
    Write-Output "Setup cancelled."
}

# Setup Application Config.
if ($(Read-Host "Proceed application and dependencies installation [y/n]") -eq "y") {
    Write-Output "Confirmed."
    Connect-Dotfiles
}
else {
    Write-Output "Setup cancelled."
}
