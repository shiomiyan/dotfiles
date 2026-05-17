{
  flake,
  pkgs,
  ...
}:

{
  imports = [
    flake.homeModules.shared
    ./windows-ssh-agent-relay.nix
  ];

  home.stateVersion = "26.05";

  xdg.configFile = {
    "git/wsl.gitconfig".text = ''
      [credential]
        helper = /mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe

      [gpg]
        program = /mnt/c/Program Files/GnuPG/bin/gpg.exe
    '';
    "zsh/wsl.zsh".source = ../../../../../config/zsh/wsl.zsh;
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "wsl-fix-interop" ''
      set -euo pipefail

      printf '%s\n' ':WSLInterop:M::MZ::/init:PF' | sudo tee /usr/lib/binfmt.d/WSLInterop.conf >/dev/null
      sudo systemctl unmask systemd-binfmt.service
      sudo systemctl restart systemd-binfmt
      sudo systemctl mask systemd-binfmt.service
    '')
  ];

}
