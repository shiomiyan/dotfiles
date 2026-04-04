mkdir -p ~/.local/bin/

ln -sf /mnt/c/Windows/explorer.exe ~/.local/bin/explorer.exe

WIN_HOME="$(wslpath "$(wslvar USERPROFILE)")"
export PATH="$WIN_HOME/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
export PATH="$WIN_HOME/AppData/Local/Programs/Zed/bin:$PATH"

# Windows SSH Agent Relay
export PATH="$PATH:/mnt/c/tools/bin"
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
