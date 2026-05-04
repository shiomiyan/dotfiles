# Dotfiles

dotfilesです。

## Setup

**Pre-requirements**: Install [Nix](https://nixos.org/download/) and [Home Manager (Standalone)](https://nix-community.github.io/home-manager/index.xhtml).

Enable nix-command and flakes, and set trusted users.

```
sudo mkdir -p /etc/nix
printf '%s\n' \
  'experimental-features = nix-command flakes' \
  'trusted-users = root sk' \
  | sudo tee /etc/nix/nix.conf
```

Deliver dotfiles.

```
home-manager switch --experimental-features "nix-command flakes" --flake ~/dotfiles#sk@wsl
```

Change default shell.

```
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

## Structure / Tech Stack

- Package and dotfiles management: Nix flakes + Home Manager
- Flake structure and conventions: [numtide/blueprint](https://numtide.github.io/blueprint/main/)
