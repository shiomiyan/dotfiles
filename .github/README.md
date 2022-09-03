## <samp>Install</samp>

Use config on Windows 10, Fedora, Pop!_OS.

### <samp>Linux, Mac<samp>

`apt` or `dnf` or `brew` needed.

```
sh -c "$(curl -fsSL https://shiomiyan.github.io/dotfiles/bin/setup-tools/bootstrap.sh)"
```

###  <samp>Windows</samp>

`winget` and `choco` and `scoop` needed.

winget will not be automatically installed. Make sure [`winget`](https://docs.microsoft.com/en-us/windows/package-manager/winget/) is installed.

```
iwr "https://shiomiyan.github.io/dotfiles/bin/setup-tools/bootstrap.ps1" -useb | iex
```
