## install

### ubuntu

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/.dotfiles/master/install.sh)"
```

### Windows

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/.dotfiles/master/src/setup.sh)"
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/shiomiyan/.dotfiles/master/src/setup.ps1)'))
```

## test in Docker

### ubuntu

```
docker build . --file ./ubuntu.dockerfile -t ubuntu-dotfiles
docker run -it ubuntu-dotfiles /bin/bash
```

### Windows

only can run on windows

```
docker build . --file ./windows.dockerfile -t windows-dotfiles
docker run -it --rm windows-dotfiles powershell.exe
```
