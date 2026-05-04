{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Commons
    git
    ripgrep
    bat
    curl
    wget
    unzip
    tig
    tree
    gh
    ghq
    fzf
    jq
    pure-prompt
    gnupg

    # Languages
    zig
    go
    clang
    nodejs
    pnpm
    rustup
    uv

    # Utilities
    ghalint
    pinact
    actionlint
    betterleaks

    # AI
    llm-agents.codex
    llm-agents.codex-acp
    llm-agents.gemini-cli
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
  };

  xdg.configFile = {
    "git" = {
      source = ../../../config/git;
      recursive = true;
    };
    "tig" = {
      source = ../../../config/tig;
      recursive = true;
    };
    "nvim" = {
      source = ../../../config/nvim;
      recursive = true;
    };
    "mise" = {
      source = ../../../config/mise;
      recursive = true;
    };
    "zsh/rc.zsh".source = ../../../config/zsh/rc.zsh;
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  home.sessionVariables = {
    LC_MESSAGES = "en_US.UTF-8";

    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";

    LESSHISTFILE = "${config.home.homeDirectory}/.local/state/less/history";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
