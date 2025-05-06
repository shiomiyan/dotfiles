## Setup on Fedora

Use [stow](https://www.gnu.org/software/stow/) to create symlinks.

```shell
sudo dnf install -y stow

# config under home directory
stow home -t "$HOME"
```

Install packages (but flaky).

```shell
./bootstrap/install.sh
```

### System

```shell
sudo stow system -vt /
sudo install -v -m 644 systemd-units/*.service -t /usr/lib/systemd/system/

# reload udev and systemd
sudo udevadm control --reload
sudo systemctl daemon-reload

# enable key-remapper services
sudo systemctl enable --now 'evremap.service' 'evremap-keychron-k2.service'
```

### Zsh

Add lines below to `/etc/zshenv` to use xdg base directory.

```shell
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
