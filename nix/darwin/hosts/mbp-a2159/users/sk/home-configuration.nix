{ flake, pkgs, ... }:
{
  imports = [ flake.homeModules."home-shared" ];

  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    agent-browser
    gemini-cli
    opencode
  ];
}
