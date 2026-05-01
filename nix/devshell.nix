{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nil
    nixfmt
    statix
    deadnix
  ];
}
