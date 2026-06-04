---
name: private-iac-credentials
description: 個人用の IaC で使うクラウドクレデンシャルを、SOPS と OpenTofu で管理するときに使う。暗号化された secret ファイルを作成または更新するとき、SOPS 管理の credential を OpenTofu に接続するとき、local state や plan file に平文を残さない構成を選ぶとき、ephemeral と sensitive、PBKDF2 による state encryption、PGP ベースの SOPS を前提に、小さく保守しやすい運用を組み立てる。
---

# SOPS OpenTofu Credentials

個人で管理する IaC の credential まわりを、小さく、保守的に保つ。変数の配線や secret 配布レイヤーを早く増やしすぎず、まずは暗号化ファイル、local state、明示的な取り扱いを優先する。

## 基本方針

- 個人用のクラウドアカウントや SaaS に使う credential は `sops` で暗号化する。
- IaC の実行エンジンには `OpenTofu` を使う。
- state は基本的に local state としつつ、state と plan の暗号化を必ず設定する。
- credential の平文残存を防ぐため、`ephemeral` な値や `sensitive` な入力を優先する。
- SOPS で管理する secret は、`ephemeral "sops_file"` と `source_file` でファイルから読む。
- input variable は、値の受け渡しや責務の分離が分かりやすい場所で使う。
- local state / plan の暗号化には、OpenTofu の `key_provider` として `PBKDF2` を基本にする。
- SOPS の暗号化方式は、明示的な別要件がない限り `PGP` を使う。

## 進め方

1. 個人用 IaC の中で、何が本当に secret なのかを見極める。
2. その値を `sops` 管理の `*.enc.yaml` に保存する。
3. `.sops.yaml` の `creation_rules` で、暗号化対象を secret ファイルだけに絞る。
4. provider や resource が直接消費できる値は、`ephemeral "sops_file"` で読むか、`sensitive` な variable で渡すかを分かりやすさで選ぶ。
5. secret を ephemeral に読んでいても、state と plan の暗号化は有効のままにする。
6. variable を使う場合は、secret の流れが追いやすい名前と責務にそろえる。

## 推奨レイアウト

構成は小さく、素直に保つ。

```text
.sops.yaml
infra/
  secrets/
    provider.enc.yaml
    runtime.enc.yaml
  secrets.tf
  variables.tf
  versions.tf
```

暗号化ファイル名は `.sops.yaml` から狙いやすいように `*.enc.yaml` を優先する。

## SOPS の設定

`.sops.yaml` は狭いルールで作成または更新する。

```yaml
creation_rules:
  - path_regex: secrets/.*\.enc\.ya?ml$
    pgp: YOUR_PGP_FINGERPRINT
```

secret ファイルは、先に平文を作ってから暗号化するのではなく、`sops` で直接編集して作る。

例:

```bash
cd infra
sops secrets/provider.enc.yaml
```

想定する中身:

```yaml
cloud_api_token: REPLACE_ME
```

保存後のファイルは暗号化されたまま Git に置く。復号済みの派生ファイルはコミットしない。個人 repo であっても扱いは変えない。

## OpenTofu での読み込みパターン

`carlpett/sops` provider を使い、暗号化ファイルから secret を ephemeral に読む。

```hcl
ephemeral "sops_file" "provider" {
  source_file = "${path.module}/secrets/provider.enc.yaml"
}

locals {
  cloud_api_token = ephemeral.sops_file.provider.data["cloud_api_token"]
}

provider "example" {
  api_token = local.cloud_api_token
}
```

credential が plan / apply 時だけ必要で、module input にする利点が薄いなら、このパターンを優先する。

## State / Plan の暗号化

local state を使いながら、state と plan の両方を `PBKDF2` と `AES-GCM` で暗号化する。

```hcl
terraform {
  encryption {
    key_provider "pbkdf2" "state_plan" {
      passphrase    = var.state_encryption_passphrase
      key_length    = 32
      iterations    = 600000
      salt_length   = 32
      hash_function = "sha512"
    }

    method "aes_gcm" "state_plan" {
      keys = key_provider.pbkdf2.state_plan
    }

    state {
      method   = method.aes_gcm.state_plan
      enforced = true
    }

    plan {
      method   = method.aes_gcm.state_plan
      enforced = true
    }
  }
}
```

passphrase が provider 評価より前に必要なら、`sops_file` から取ろうとせず input variable を使う。

## Variable の扱い

secret 用 variable の基本:

- secret を受ける variable には `sensitive` を付ける。
- OpenTofu の version と用途が対応していれば `ephemeral` も使う。
- provider 直結でも module input でも、どこで値が入ってどこで消費されるかを追いやすく保つ。
- 対話入力、`.tfvars`, 環境変数, `sops_file` のどれから渡すかを早めに決めて混在を増やしすぎない。

例:

```hcl
variable "state_encryption_passphrase" {
  type      = string
  sensitive = true
  ephemeral = true
}
```

## ガードレール

- secret を追跡対象ファイルへ復号しない。
- credential を output 経由で外へ出さない。
- variable を使う場合でも、同じ secret の受け渡し経路を増やしすぎない。
- 個人用だからといって、state や plan に平文が残る構成を許容しない。
- `sensitive` だけで state から消えると思い込まない。
- `sops_file` が ephemeral だからといって state / plan の暗号化を省略しない。

## 判断の目安

- credential が provider や resource の実行時にだけ必要で、module 境界もまたがないなら、`ephemeral "sops_file"` を優先する。
- secret が `terraform { encryption {} }` の評価前に必要なら、対話入力の variable を使う。
- module に渡したい、責務を分けたい、テストしやすくしたいなら variable を使う。
