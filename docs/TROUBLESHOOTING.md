## Windows側のバイナリが実行できなくなる

何かの拍子で`WSLInterop`が無効になってしまうケースがある。

```
❯ cat /proc/sys/fs/binfmt_misc/WSLInterop
cat: /proc/sys/fs/binfmt_misc/WSLInterop: No such file or directory
```

少なくともNixOS WSLでは、`binfmt`サービスを再起動することで解消した。

```
sudo systemctl restart systemd-binfmt
```

NixOS WSL以外では[microsoft/WSLのIssue](https://github.com/microsoft/WSL/issues/8952#issuecomment-1572193568)を参考に、`wsl-fix-interop`コマンドを用意している。
