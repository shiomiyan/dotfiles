{
  flake,
  pkgs,
  ...
}:

{
  imports = [
    flake.homeModules.common
  ];

  home.stateVersion = "26.05";

  xdg.configFile = {
    "git/wsl.gitconfig".text = ''
      [credential]
        helper = /mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe
    '';
    "zsh/wsl.zsh".source = ../../../../../home/.config/zsh/wsl.zsh;
  };

  home.packages = with pkgs; [
    socat
    (pkgs.writeShellScriptBin "wsl-fix-interop" ''
      set -euo pipefail

      printf '%s\n' ':WSLInterop:M::MZ::/init:PF' | sudo tee /usr/lib/binfmt.d/WSLInterop.conf >/dev/null
      sudo systemctl unmask systemd-binfmt.service
      sudo systemctl restart systemd-binfmt
      sudo systemctl mask systemd-binfmt.service
    '')
  ];

  systemd.user.services.windows-ssh-agent-relay = {
    Unit = {
      Description = "Windows OpenSSH Agent relay for WSL";
      ConditionPathExists = "/mnt/c/tools/bin/npiperelay.exe";
    };

    Service = {
      Restart = "on-failure";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p %h/.ssh"
        "${pkgs.coreutils}/bin/rm -f %h/.ssh/agent.sock"
      ];
      ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:%h/.ssh/agent.sock,fork EXEC:'/mnt/c/tools/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent',nofork";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f %h/.ssh/agent.sock";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
