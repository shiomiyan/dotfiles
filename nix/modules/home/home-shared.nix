{
  config,
  inputs,
  perSystem,
  pkgs,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  xdg.enable = true;

  home = {
    packages =
      with pkgs;
      [
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
        opentofu
        pinact
        tig
        cloudflared

        # Languages
        clang
        go
        rustup
        uv
        zig

        # GPG support
        pcsc-tools
        sops
        usbutils

        # Misc
        bitwarden-cli
        ast-grep
        ffmpeg
      ]
      ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        # Keep the scope local so package names stay short without broadening
        # lookup rules for the rest of home.packages.
        gemini-cli
        opencode
      ]);

    sessionVariables = {
      LC_MESSAGES = "en_US.UTF-8";

      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
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
    "opencode/opencode.jsonc".source = ../../../config/opencode/opencode.jsonc;
    "opencode/AGENTS.md".source = ../../../config/opencode/AGENTS.md;
    "zsh/rc.zsh".source = ../../../config/zsh/rc.zsh;
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

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

    chromium = {
      enable = true;
    };

    #atuin = {
    #  enable = true;
    #  enableZshIntegration = true;
    #  flags = [ "--disable-up-arrow" ];
    #  settings = {
    #    auto_sync = true;
    #    enter_accept = false;
    #    style = "compact";
    #    records = true;
    #  };
    #  daemon = {
    #    enable = true;
    #  };
    #};

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
      globalConfig.settings.all_compile = false;
      globalConfig.tools = {
        bun = "latest";
        deno = "latest";
        node = "24.19.0";
        pnpm = "11.22.0";
        "npm:agent-browser" = {
          version = "0.38.1";
          allow_builds = [ "agent-browser" ];
        };
      };
    };

    gpg = {
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

    home-manager.enable = true;
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
