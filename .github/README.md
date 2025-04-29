## Setup on Fedora

一応bootstrapスクリプトを用意している。

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/dotfiles/master/bootstrap/bootstrap.sh)"
```

ただ、セットアップ頻度自体が少なくflakyになりがちなので、必要になったらインストールしていくほうが無難。

### Zsh

自動化してないので手でやる。Zshとそのプラグインマネージャーを入れる。

```
sudo dnf install -y zsh
cargo install sheldon
```

`/etc/zshenv`に以下を追記する。

```
export XDG_CONFIG_HOME="$HOME/.config/"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
```

Zshの設定にsymlinkを張る。

```
ln -s ~/dotfiles/config/zsh ~/.config/zsh
```

## macOS

`dnf` or `brew` needed.

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/dotfiles/master/bootstrap/bootstrap.sh)"
```

## Windows

`winget` and `choco` and `scoop` needed.

Winget will not be automatically installed. Make sure [`winget`](https://docs.microsoft.com/en-us/windows/package-manager/winget/) is installed.

```powershell
iwr "https://shiomiyan.github.io/dotfiles/bootstrap/bootstrap.ps1" -useb | iex
```
