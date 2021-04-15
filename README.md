_unix and macOS setup_
```shell
$ git clone --recursive https://github.com/shiomiyan/.dotfiles ~/.dotfiles
$ cd .dotfiles
$ ./install.sh
```

or

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shiomiyan/dotfiles/master/install.sh)"
```

_Windows setup_
- Rust
  - Rustup https://www.rust-lang.org/tools/install
  - Build Tools https://visualstudio.microsoft.com/ja/visual-cpp-build-tools/
- Git
  - Git for Windows https://git-scm.com/download/win
  - PowerShell Git environment http://dahlbyk.github.io/posh-git/
  - SSH connection ( `ssh-keygen -t rsa -b 4096 -C "e-mail address"` )
