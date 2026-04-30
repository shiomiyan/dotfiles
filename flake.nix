{
  description = "Home Manager configuration of sk";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      llm-agents,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ llm-agents.overlays.default ];
      };
    in
    {
      homeConfigurations = {
        "default" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./common.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        "wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./common.nix
            ./wsl.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nil
          pkgs.nixfmt
          statix
          deadnix
        ];
      };
    };
}
