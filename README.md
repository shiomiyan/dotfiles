_unix and macOS setup_

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/.dotfiles/master/install.sh)"
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
docker run -it windows-dotfiles powershell.exe
```
