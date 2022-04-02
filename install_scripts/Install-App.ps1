# allow script execution
Set-ExecutionPolicy Bypass -Force

# install chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# always enable -y option
choco feature enable -n allowGlobalConfirmation

# install applications using choco
cinst neovim git alacritty wezterm

# neovim dependencies
cinst nodejs-lts deno

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

# Install rust-analyzer
New-Item -ItemType Directory -Path "~/.local/bin"
Invoke-WebRequest `
    -Uri "https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-pc-windows-msvc.gz" `
    -OutFile "~/.local/bin/rust-analyzer.gz"
& 'C:\Program Files\7-Zip\7z.exe' x "~/.local/bin/rust-analyzer.gz" "~/.local/bin/rust-analyzer.exe"
Remove-Item -Force ~/.local/bin/rust-analyzer.gz

# Install Neovim vim-plug
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
