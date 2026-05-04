# Dotfiles

dotfilesです。

## Setup

### Standalone with Home Manager

**Pre-requirements**: Install [Nix](https://nixos.org/download/) and [Home Manager (Standalone)](https://nix-community.github.io/home-manager/index.xhtml).

Deliver dotfiles.

```
home-manager switch --experimental-features "nix-command flakes" --flake ~/dotfiles#sk@wsl
```

Change default shell.

```
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### NixOS-WSL

Install [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/index.html).

Clone, bootstrapping.

```
cd dotfiles
sudo nixos-rebuild switch --experimental-features "nix-command flakes" --flake .#wsl
```

## Structure / Tech Stack

- Package and dotfiles management: Nix flakes + Home Manager
- Flake structure and conventions: [numtide/blueprint](https://numtide.github.io/blueprint/main/)
