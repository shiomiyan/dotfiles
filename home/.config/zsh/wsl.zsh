mkdir -p ~/.local/bin/

ln -sf /mnt/c/Windows/explorer.exe ~/.local/bin/explorer.exe

export PATH="$HOME/winhome/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

# Windows SSH Agent Relay
PATH=$PATH:~/.local/bin
export SSH_AUTH_SOCK=${HOME}/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0   ]; then
 rm -f ${SSH_AUTH_SOCK}
 ( setsid socat UNIX-LISTEN:${SSH_AUTH_SOCK},fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
fi
