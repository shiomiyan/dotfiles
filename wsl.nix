{ pkgs, ... }:

{
  home.packages = with pkgs; [
    socat
    wslu
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
