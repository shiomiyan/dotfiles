### Linux or Mac

`dnf` or `brew` needed.

```
bash -c "$(curl -fsSL https://shiomiyan.github.io/dotfiles/bin/setup-tools/bootstrap.sh)"
```

### Windows

`winget` and `choco` and `scoop` needed.

Winget will not be automatically installed. Make sure [`winget`](https://docs.microsoft.com/en-us/windows/package-manager/winget/) is installed.

```
iwr "https://shiomiyan.github.io/dotfiles/bin/setup-tools/bootstrap.ps1" -useb | iex
```
