# GPG鍵管理

YubiKeyを中心にGPG鍵を管理している。

| Use case | Key capability | Key location |
| --- | --- | --- |
| GitHub commit/tag signing | `[S]` signing | Local per-device subkey |
| GitHub SSH authentication | `[A]` authentication | YubiKey |
| OpenPGP decryption | `[E]` encryption | YubiKey |
| OpenPGP key management | `[C]` certification | YubiKey |

## Windows端末

- 端末には、Git commit/tag署名用のサブキーを置く。
- 端末ごとに別の署名サブキーを持たせる。端末をなくした場合は、その端末の署名サブキーだけを失効する。

## GitHubで使うもの

GitHubには、主キーfingerprintでexportした公開鍵ブロックを登録する。

```plaintext
gpg --armor --export 30B3D66B945D4F401B63338C0D24BF6D3FBDACB0 > github-gpg-public.asc
```

この公開鍵ブロックには、主キー公開鍵、UID、暗号化サブキー公開鍵、各端末用の署名サブキー公開鍵が含まれる。

署名サブキーを追加または失効したら、公開鍵ブロックを再exportしてGitHubへ登録し直す。

## Gitで使うもの

- Gitには、端末用署名サブキーではなく主キーfingerprintを指定する。
  - サブキーfingerprintにはしない。`!` も付けない。
- WSLでは、Windows側のGpg4winを使う。

## バックアップ

下記は別途バックアップを作成している。

- primary-secret-full-backup.asc
  - 主キーの秘密鍵。YubiKey交換など、移行時に使う。
- primary-revocation.asc
  - 主キーを失効するための証明書。鍵漏洩時などに使う。

端末用署名サブキーの秘密鍵は基本バックアップせず、割とカジュアルに失効・再発行する。

## 端末移行時

新しい端末では、まず公開鍵をimportする。

```plaintext
gpg --import ./public.asc
```

YubiKeyを挿して、鍵が見えることを確認する。

```plaintext
gpg --card-status
gpg --list-secret-keys --with-subkey-fingerprints --keyid-format=long 30B3D66B945D4F401B63338C0D24BF6D3FBDACB0
```

新しい端末用の署名サブキーを発行する。

```plaintext
gpg --quick-add-key 30B3D66B945D4F401B63338C0D24BF6D3FBDACB0 ed25519 sign never
```

新しい `[S]` サブキーが追加され、`>` が付いていなければ、その端末上に秘密サブキーがある。

次に、GitHub登録用の公開鍵ブロックを更新する。

```plaintext
gpg --armor --export 30B3D66B945D4F401B63338C0D24BF6D3FBDACB0 > github-gpg-public.asc
```

GitHubのGPG keyを登録し直す。
