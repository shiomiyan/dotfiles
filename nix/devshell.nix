{
  inputs,
  perSystem,
  pkgs,
  system,
  ...
}:

let
  git-hooks = inputs.git-hooks.lib.${system};
  preCommitCheck = git-hooks.run {
    src = ../.;
    package = pkgs.prek;
    hooks = {
      actionlint.enable = true;
      pinact = {
        enable = true;
        package = pkgs.pinact;
        entry = "${pkgs.pinact}/bin/pinact run --fix=false --no-api";
        files = "^\\.github/workflows/.*\\.ya?ml$";
      };
      treefmt = {
        enable = true;
        package = perSystem.self.formatter;
      };
    };
  };
in
pkgs.mkShellNoCC {
  inherit (preCommitCheck) shellHook;

  packages =
    (with pkgs; [
      nixd
      nil
      statix
      deadnix
      opentofu
      mcp-nixos
    ])
    ++ preCommitCheck.enabledPackages;

}
