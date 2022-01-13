# allow script execution
Set-ExecutionPolicy Bypass -Force

# install chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# always enable -y option
choco feature enable -n allowGlobalConfirmation

# install applications using choco
cinst neovim git alacritty

# download win32yank for sync clipboard
Invoke-WebRequest `
    -Uri "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip" `
    -OutFile C:\win32yank.zip
Expand-Archive C:\win32yank.zip -DestinationPath C:\Tools\win32yank
Remove-Item -Force C:\win32yank.zip

# install Rust
Invoke-WebRequest `
    -Uri "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" `
    -OutFile C:\rustup-init.exe
C:\rustup-init.exe -y
Remove-Item -Force C:\rustup-init.exe
