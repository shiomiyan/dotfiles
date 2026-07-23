# WSL

WSL では、SSH と GPG で通る経路が異なる。

**SSH Agent** は、Windows の OpenSSH agent を `npiperelay.exe` と `socat` で WSL に中継する。

**GPG Agent** は、用途ごとに二つに分かれる。

- Git の署名では、WSL の Git から Windows 側の `gpg.exe` を呼ぶ。
- YubiKey を使うカード操作や SOPS の復号では、WSL 側の `gpg` が `pcscd` 経由でカードを読む。

この区別を外すと、関係のない場所を調べ続ける。

たとえば `ssh-add -L` が失敗しているのに `pcscd` を見ても直らない。

逆に `gpg --card-status` が失敗しているのに `npiperelay.exe` を見ても直らない。

## SSH Agent

まず確認するのは、WSL から見えている `SSH_AUTH_SOCK` が期待したソケットかどうかである。

```bash
echo "$SSH_AUTH_SOCK"
```

この設定では、`SSH_AUTH_SOCK` は `~/.ssh/agent.sock` を指す。

これは、user service の `windows-ssh-agent-relay` が毎回作り直すソケットである。

```bash
systemctl --user status windows-ssh-agent-relay
ls -l ~/.ssh/agent.sock
```

`systemctl --user` が失敗するなら、relay 自体が起動していない。

`~/.ssh/agent.sock` が無いなら、`socat` まで到達していない。

この service は `npiperelay.exe` を前提にする。

そのため、Windows 側に `/mnt/c/tools/bin/npiperelay.exe` が無ければ起動しない。

```bash
ls /mnt/c/tools/bin/npiperelay.exe
```

次に、実際の SSH 認証経路を見る。

```bash
ssh -vvv pi@<host>
```

この環境では、`ssh-add -L` が `agent refused operation` を返しても、`ssh` 本体は relay 越しに接続できることがある。

そのため、`ssh-add -L` の失敗だけで relay 不良とは決めない。

`ssh -vvv` で `Offering public key:` まで進み、その鍵で認証に成功するかを優先して見る。

`ssh-add -L` が `The agent has no identities.` を返すなら、relay は動いているが Windows 側 agent に鍵が載っていない。

その場合は WSL ではなく Windows 側の OpenSSH agent を確認する。

Windows では `ssh -o PubkeyAuthentication=unbound ...` が必要でも、WSL では同じ指定が失敗することがある。

この環境の WSL OpenSSH 10.3p1 では、`PubkeyAuthentication=unbound` を付けると relay された Windows agent が `agent refused operation` を返し、鍵一覧の取得に失敗した。

一方で、`PubkeyAuthentication yes` のままなら、一度 host-bound 側を拒否された後に fallback して認証できた。

そのため、WSL 側では `PubkeyAuthentication=unbound` を使わないほうが安定する。

## GPG 署名の確認

Git の署名では、WSL の `gpg` を使っているとは限らない。

この設定では、Git だけが Windows 側の `gpg.exe` を明示的に呼ぶ。

```bash
git config --show-origin --get gpg.program
git config --show-origin --get user.signingkey
```

`gpg.program` が `/mnt/c/Program Files/GnuPG/bin/gpg.exe` を指していれば、`git commit -S` は Windows 側 GnuPG に依存する。

したがって、`git commit -S` の失敗は、まず Windows 側 GnuPG と pinentry を疑う。

WSL 側の `gpg --card-status` が失敗していても、Git 署名の失敗原因とは限らない。

逆に `git commit -S` だけ失敗するなら、`usbip` や `pcscd` を見ても外れることがある。

WSL から Windows バイナリを起動できない場合は、`WSLInterop` の破損も疑う。

```bash
git config --show-origin --get gpg.program
/mnt/c/Program\ Files/GnuPG/bin/gpg.exe --version
```

ここで Windows 側バイナリを実行できないなら、[TROUBLESHOOTING.md](./TROUBLESHOOTING.md) の `WSLInterop` 復旧手順を先に使う。

## GPG カード操作の確認

`gpg --card-status` は、Git 署名とは別系統である。

ここで見ているのは、WSL 側 `gpg` と `scdaemon` が YubiKey を読めるかどうかである。

```bash
gpg --card-status
gpgconf --kill scdaemon
gpg --card-status
```

`No such device` なら、GPG がカード自体を見つけられていない。

この設定では `scdaemon` に `disable-ccid = true` を入れている。

そのため、WSL 側 `gpg` は内蔵 CCID ではなく `pcscd` 経由でカードを探す。

ここで確認すべき順序は次のとおりである。

1. `pcscd` が起動しているか。
2. WSL に USB デバイスが attach されているか。
3. `scdaemon` の古い状態が残っていないか。

```bash
systemctl status pcscd
pcsc_scan
gpgconf --kill scdaemon
gpg --card-status
```

`pcsc_scan` でカードが見えないなら、問題は GPG より手前にある。

その場合は `usbip` の attach 状態を確認する。

Windows 側では、少なくとも次を確認する。

```powershell
usbipd list
usbipd attach --wsl --busid <BUSID>
```

`pcsc_scan` では見えるのに `gpg --card-status` だけ失敗するなら、`scdaemon` の状態を疑う。

`gpgconf --kill scdaemon` の後でも再現するなら、`pcscd` と `ccid` plugin の組み合わせを確認する。

## 症状ごとの見分け方

- `ssh -vvv` でも公開鍵提示まで進まない: `windows-ssh-agent-relay`、`SSH_AUTH_SOCK`、`npiperelay.exe` を見る。
- `ssh-add -L` だけ失敗する: まず `ssh -vvv` で実際の認証可否を見る。
- `git commit -S` が失敗する: `git config` の `gpg.program`、Windows 側 `gpg.exe`、`WSLInterop` を見る。
- `gpg --card-status` が失敗する: `usbip`、`pcscd`、`pcsc_scan`、`scdaemon` を見る。

同じマシンでも、三つの症状は別々に壊れる。

そのため、最初に失敗したコマンドを基準に経路を選ぶほうが早い。
