## Setup on Fedora

Use [stow](https://www.gnu.org/software/stow/) to create symlinks.

```shell
sudo dnf install -y stow

# config under home directory
stow home -vt "$HOME"
```

Install packages (but flaky).

```shell
./bootstrap/install.sh
```

### System

```shell
# create system configuration symlinks
sudo stow system -vt /

# enable key-remapper services
systemctl --user enable --now 'xremap.service'
```

### Zsh

Add lines below to `/etc/zshenv` to use xdg base directory.

```shell
export XDG_CONFIG_HOME="$HOME/.config/"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
```

## Help

Example to apply changes.

```
stow home -R
```
