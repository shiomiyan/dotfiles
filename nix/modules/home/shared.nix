{
  config,
  inputs,
  perSystem,
  pkgs,
  ...
}:

{
  imports = [
    inputs.agent-skills.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    # Shell tools
    bat
    curl
    fzf
    jq
    perSystem.self.mo
    pure-prompt
    ripgrep
    tree
    unzip
    wget

    # Development
    ghalint
    gh
    ghq
    git
    actionlint
    betterleaks
    devenv
    pinact
    tig

    # Languages
    clang
    go
    nodejs
    pnpm
    rustup
    uv
    zig

    # GPG support
    pcsc-tools
    sops
    usbutils

    # AI
    llm-agents.codex
    llm-agents.codex-acp
    llm-agents.gemini-cli

    # Misc
    bitwarden-cli
  ];

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
    "zsh/rc.zsh".source = ../../../config/zsh/rc.zsh;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
    globalConfig.tools = {
      bun = "latest";
      deno = "latest";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    publicKeys = [
      {
        source = ../../../keys/openpgp/shiomiyan.asc;
      }
    ];
    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-all}/bin/pinentry
    '';
  };

  programs.agent-skills = {
    enable = true;
    sources.grill-me = {
      input = "grill-me";
      subdir = "skills";
    };
    skills.enable = [
      "productivity/grill-me"
    ];
    targets.codex = {
      enable = true;
      structure = "copy-tree";
    };
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
