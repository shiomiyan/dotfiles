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
        inputs.crit.packages.${pkgs.stdenv.hostPlatform.system}.default

        # Misc
        bitwarden-cli
        ast-grep
      ]
      ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        # Keep the scope local so package names stay short without broadening
        # lookup rules for the rest of home.packages.
        codex
        codex-acp
        gemini-cli
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
    "emacs" = {
      source = ../../../config/emacs;
      recursive = true;
    };
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

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };

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

    atuin = {
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
      globalConfig.tools = {
        bun = "latest";
        deno = "latest";
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

    agent-skills = {
      enable = true;
      sources = {
        grill-me = {
          input = "grill-me";
          subdir = "skills";
        };
        superpowers = {
          input = "superpowers";
          subdir = "skills";
        };
        dotfiles = {
          path = ../../../config/agent-skills;
        };
      };
      skills.enable = [
        "productivity/grill-me"
        # Enable the Superpowers entrypoint first so the workflow can opt into
        # additional skills later without committing to the full methodology now.
        "using-superpowers"
        "jtf-documentation-style"
        "japanese-tech-writing"
        "private-iac-credentials"
      ];
      targets.codex = {
        enable = true;
        structure = "copy-tree";
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
