{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sk";
  home.homeDirectory = "/home/sk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Commons
    pkgs.git
    pkgs.zsh
    pkgs.ripgrep
    pkgs.bat
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.tig
    pkgs.gh
    pkgs.mise

    # Languages
    pkgs.nodejs
    pkgs.deno
    pkgs.zig
    pkgs.rustup

    # Misc
    pkgs.codex
    pkgs.codex-acp
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      enter_accept = false;
      style = "compact";
      records = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    initContent = lib.mkOrder 1500 ''
      [ -r "$ZDOTDIR/rc.zsh" ] && source "$ZDOTDIR/rc.zsh"
    '';

    plugins = [ ];
  };

  xdg.configFile = {
    "git" = {
      source = ./home/.config/git;
      recursive = true;
    };
    "tig" = {
      source = ./home/.config/tig;
      recursive = true;
    };
    "nvim" = {
      source = ./home/.config/nvim;
      recursive = true;
    };
    "mise" = {
      source = ./home/.config/mise;
      recursive = true;
    };
    "zsh/rc.zsh".source = ./home/.config/zsh/rc.zsh;
    "zsh/wsl.zsh".source = ./home/.config/zsh/wsl.zsh;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sk/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
