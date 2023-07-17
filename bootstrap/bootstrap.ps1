[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Allow script execution
Set-ExecutionPolicy Bypass -Force

function local:Install-Apps {
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

    # Install scoop if not exists
    if (-not (Get-Command scoop -ea SilentlyContinue)) {
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    }

    # Add scoop buckets
    scoop bucket add extras
    scoop bucket add versions

    # Clone repo if not exists
    if (!(Test-Path "$HOME\dotfiles")) {
        git clone https://github.com/shiomiyan/dotfiles.git $HOME/dotfiles
    }

    # Install runtimes, commandline tools
    $apps = @{
        winget = @(
            # Dev utilities
            "Microsoft.VisualStudio.2019.BuildTools",
            "Git.Git",
            "Microsoft.VisualStudioCode",
            "wez.wezterm",
            "Microsoft.PowerShell",
            "Neovim.Neovim",
            # Other utilities
            "7zip.7zip",
            "Audacity.Audacity",
            "Avidemux.Avidemux",
            "AntoineAflalo.SoundSwitch",
            "CPUID.HWMonitor",
            "Discord.Discord",
            "Mozilla.Firefox",
            "Spotify.Spotify",
            "Valve.Steam",
            "VideoLAN.VLC"

        );
        scoop = @(
            "make",
            "gh",
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
    $apps.winget | ForEach-Object { winget install -y $_ }
    $apps.scoop | ForEach-Object { scoop install $_ }

    # Install Rust
    Invoke-WebRequest `
        -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
        -OutFile C:\rustup-init.exe
    C:\Temp\rustup-init.exe -y
    Remove-Item -Force C:\Temp\rustup-init.exe

    refreshenv
}

function local:Invoke-Create-Symlink {

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
} else {
    Write-Output "Setup cancelled."
}

# Setup Application Config.
if ($(Read-Host "Proceed application and dependencies installation [y/n]") -eq "y") {
    Write-Output "Confirmed."
    Invoke-Create-Symlink
} else {
    Write-Output "Setup cancelled."
}
