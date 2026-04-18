# Dotfiles

dotfilesです。

## Setup

**Pre-requirements**: Install [Nix](https://nixos.org/download/) and [Home Manager (Standalone)](https://nix-community.github.io/home-manager/index.xhtml).

Enable nix-command and flakes.

```
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Deliver dotfiles.

```
home-manager switch --flake ~/dotfiles#default
```

Use the WSL-specific profile on WSL.

```
home-manager switch --flake ~/dotfiles#wsl
```

Change default shell.

```
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```
