# Dotfiles

dotfilesです。

## Setup

### Standalone with Home Manager

**Pre-requirements**: Install [Nix](https://nixos.org/download/) and [Home Manager (Standalone)](https://nix-community.github.io/home-manager/index.xhtml).

Deliver dotfiles.

```plaintext
home-manager switch --experimental-features "nix-command flakes" --flake ~/dotfiles#sk@wsl
```

Change default shell.

```plaintext
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### NixOS-WSL

Install [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/index.html).

Clone, bootstrapping.

```plaintext
cd dotfiles
sudo nixos-rebuild switch --experimental-features "nix-command flakes" --flake .#wsl
```

## Structure / Tech Stack

Flake structure: [numtide/blueprint](https://numtide.github.io/blueprint/main/)

- `bootstrap/`: Initial setup scripts for tools that remain outside Home Manager.
- `config/`: Source files linked into XDG config locations by Home Manager.
- `docs/`: Operational notes for manual procedures.
- `keys/`: Public key material that is safe to keep in the repository.
- `nix/`: NixOS, Home Manager, package, formatter, and development shell definitions.
