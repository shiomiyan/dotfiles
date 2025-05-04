## Setup on Fedora

Use [stow](https://www.gnu.org/software/stow/) to create symlinks.

```
sudo dnf install -y stow

# config under home directory
stow home -t "$HOME"
```

Install packages (but flaky).

```shell
./bootstrap/install.sh
```

### Zsh

Manual.

```
sudo dnf install -y zsh
cargo install sheldon
```

Add lines below to `/etc/zshenv`.

```
export XDG_CONFIG_HOME="$HOME/.config/"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
```

## Setup on Windows

`winget` and `choco` and `scoop` needed.

```powershell
iwr "https://shiomiyan.github.io/dotfiles/bootstrap/bootstrap.ps1" -useb | iex
```

## Help

Example to apply changes.

```
stow home -R
```
