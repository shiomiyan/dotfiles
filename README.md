_unix and macOS setup_

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/.dotfiles/master/install.sh)"
```

_Windows setup_
- Rust
  - Rustup https://www.rust-lang.org/tools/install
  - Build Tools https://visualstudio.microsoft.com/ja/visual-cpp-build-tools/
- Git
  - Git for Windows https://git-scm.com/download/win
  - PowerShell Git environment http://dahlbyk.github.io/posh-git/
  - SSH connection ( `ssh-keygen -t rsa -b 4096 -C "e-mail address"` )

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
