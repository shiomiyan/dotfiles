{
  inputs,
  pkgs,
  system,
  ...
}:

let
  preCommitCheck = inputs.git-hooks.lib.${system}.run {
    src = ../.;
    package = pkgs.prek;
    hooks.betterleaks = {
      enable = true;
      name = "Detect hardcoded secrets";
      description = "Detect hardcoded secrets using Betterleaks";
      entry = "betterleaks git --pre-commit --redact --staged --no-banner";
      language = "system";
      pass_filenames = false;
      stages = [ "pre-commit" ];
      package = pkgs.betterleaks;
    };
  };
in
pkgs.mkShell {
  packages =
    (with pkgs; [
      nixd
      nil
      nixfmt
      statix
      deadnix
      terraform
    ])
    ++ preCommitCheck.enabledPackages;

  shellHook = preCommitCheck.shellHook;
}
