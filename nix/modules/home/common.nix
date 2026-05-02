{
  config,
  pkgs,
  ...
}:

{
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
    pkgs.tree
    pkgs.gh
    pkgs.ghq
    pkgs.fzf
    pkgs.jq

    # Languages
    pkgs.zig
    pkgs.go
    pkgs.clang
    pkgs.nodejs
    pkgs.pnpm
    pkgs.rustup

    # Utilities
    pkgs.ghalint
    pkgs.pinact
    pkgs.actionlint
    pkgs.betterleaks

    # AI
    pkgs.llm-agents.codex
    pkgs.llm-agents.codex-acp
    pkgs.llm-agents.gemini-cli

    # Misc
    pkgs.pure-prompt
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
    daemon = {
      enable = true;
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

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    initContent = ''
      autoload -Uz promptinit
      promptinit
      prompt pure

      [ -r "$ZDOTDIR/rc.zsh" ] && source "$ZDOTDIR/rc.zsh"
    '';

    plugins = [
      {
        name = "pure";
        src = pkgs.pure-prompt;
      }
    ];
  };

  xdg.configFile = {
    "git" = {
      source = ../../../home/.config/git;
      recursive = true;
    };
    "tig" = {
      source = ../../../home/.config/tig;
      recursive = true;
    };
    "nvim" = {
      source = ../../../home/.config/nvim;
      recursive = true;
    };
    "mise" = {
      source = ../../../home/.config/mise;
      recursive = true;
    };
    "zsh/rc.zsh".source = ../../../home/.config/zsh/rc.zsh;
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
    LESSHISTFILE = "${config.home.homeDirectory}/.local/state/less/history";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
