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
