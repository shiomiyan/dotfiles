### Linux or Mac

`dnf` or `brew` needed.

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/dotfiles/master/bootstrap/bootstrap.sh)"
```

- https://sheldon.cli.rs/Installation.html
- https://github.com/wez/evremap
  - `sudo dnf group install 'development-tools'`
  - `sudo dnf install -y libevdev-devel`
  - clone repo, build it, `sudo cp target/release/evremap /usr/bin/evremap`

### Windows

`winget` and `choco` and `scoop` needed.

Winget will not be automatically installed. Make sure [`winget`](https://docs.microsoft.com/en-us/windows/package-manager/winget/) is installed.

```powershell
iwr "https://shiomiyan.github.io/dotfiles/bootstrap/bootstrap.ps1" -useb | iex
```
