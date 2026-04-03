mkdir -p ~/.local/bin/

ln -sf /mnt/c/Windows/explorer.exe ~/.local/bin/explorer.exe

WIN_HOME="$(wslpath "$(wslvar USERPROFILE)")"
export PATH="$WIN_HOME/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

# Windows SSH Agent Relay
export PATH="$PATH:/mnt/c/tools/bin"
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0   ]; then
 rm -f ${SSH_AUTH_SOCK}
 ( setsid socat UNIX-LISTEN:${SSH_AUTH_SOCK},fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
fi
