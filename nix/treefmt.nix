{ ... }:
{
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.stylua = {
    enable = true;
    includes = [
      "config/nvim/*.lua"
      "config/nvim/**/*.lua"
      "config/wezterm/*.lua"
      "config/wezterm/**/*.lua"
    ];
    settings = {
      indent_type = "Spaces";
      indent_width = 2;
    };
  };
}
