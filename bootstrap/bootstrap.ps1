[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Allow script execution
Set-ExecutionPolicy Bypass -Force

function local:Install-App {
    <#

.DESCRIPTION
    Function for install require applications and dependencies

#>

    if (!(Test-Path "C:\Temp")) {
        mkdir C:\Temp
    }

    # Install winget if not exists
    if (-not (Get-Command winget -ea SilentlyContinue)) {
        # install dependencies for winget
        $wingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Invoke-WebRequest -Uri $wingetUrl -OutFile "C:\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        Import-Module Appx -UseWindowsPowerShell
        try {
            Add-AppxPackage C:\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
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
    #winget import -i "$HOME\dotfiles\bootstrap\winget.json"

    # Add scoop buckets
    scoop bucket add extras
    scoop bucket add versions

    # Install runtimes, commandline tools
    $apps = @{
        winget = @(
            "Microsoft.VisualStudio.2019.BuildTools",
            "Audacity.Audacity",
            "CPUID.HWMonitor",
            "Discord.Discord",
            "Git.Git",
            "Mozilla.Firefox",
            "AntoineAflalo.SoundSwitch",
            "Spotify.Spotify",
            "Valve.Steam",
            "VideoLAN.VLC",
            "7zip.7zip",
            "Microsoft.VisualStudioCode",
            "wez.wezterm",
            "Microsoft.PowerShell",
            "Avidemux.Avidemux"
        );
        choco = @(
            "neovim",
            "espanso"
        );
        scoop = @(
            "make",
            "gh",
            "ghq",
            "peco",
            "sudo",
            "deno",
            "nodejs-lts",
            "starship",
            "bat",
            "lsd",
            "zoxide",
            "fd",
            "ripgrep",
            "rga",
            "hugo-extended"
        )
    }
    $apps.scoop | ForEach-Object { scoop install $_ }

    # Always enable -y option
    choco feature enable -n allowGlobalConfirmation

    # Install applications using choco
    $apps.choco | ForEach-Object { choco install $_ --pre }

    # Install Rust
    Invoke-WebRequest `
        -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
        -OutFile C:\rustup-init.exe
    C:\Temp\rustup-init.exe -y
    Remove-Item -Force C:\Temp\rustup-init.exe

    refreshenv

}

function local:Create-Symlink {

    <#

.DESCRIPTION
    Function that craete symbolic links

#>

    if (-not (Test-Path "$HOME\.config")) {
        mkdir $HOME\.config
    }

    New-Item -ItemType SymbolicLink `
        -Path   $HOME\Documents\PowerShell `
        -Target $HOME\dotfiles\config\powershell

    New-Item -ItemType SymbolicLink `
        -Path   $HOME\.config\wezterm `
        -Target $HOME\dotfiles\config\wezterm

    New-Item -ItemType SymbolicLink `
        -Path   $env:LOCALAPPDATA\nvim `
        -Target $HOME\dotfiles\config\nvim\

    New-item -ItemType SymbolicLink `
        -Path   $env:APPDATA\espanso `
        -Target $HOME\dotfiles\config\espanso

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
