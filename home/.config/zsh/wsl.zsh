mkdir -p ~/.local/bin/

ln -sf /mnt/c/Windows/explorer.exe ~/.local/bin/explorer.exe

WIN_HOME="$(wslpath -u "$(/mnt/c/Windows/System32/cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')" 2>/dev/null)"
if [[ -z "$WIN_HOME" ]]; then
  WIN_HOME="/mnt/c/Users/$USER"
fi
export PATH="$WIN_HOME/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
export PATH="$WIN_HOME/AppData/Local/Programs/Zed/bin:$PATH"

# Windows SSH Agent Relay
export PATH="$PATH:/mnt/c/tools/bin"
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
