
# 基本的にappendWindowsPath=falseなので、explorer.exeを開けるようにしておく
if [[ ! -x "$(command -v explorer.exe)" ]]; then
  mkdir -p "$HOME/.local/bin"
  ln -sfn /mnt/c/Windows/explorer.exe "$HOME/.local/bin/explorer.exe"
fi

WIN_HOME="$(wslpath -u "$(/mnt/c/Windows/System32/cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')" 2>/dev/null)"
export PATH="$WIN_HOME/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
export PATH="$WIN_HOME/AppData/Local/Programs/Zed/bin:$PATH"

# Windows SSH Agent Relay
export PATH="$PATH:/mnt/c/tools/bin"
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
