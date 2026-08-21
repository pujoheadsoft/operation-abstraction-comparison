# 操作の抽象化の比較: 実行可能なコード例

関数型プログラミングにおける6つのアプローチを、同じ題材で比較するための実行可能なサンプルです。
すべての例で、`calculateTotal subtotal` は割引額と送料を求め、合計額を返します。

ここでの6つは、同一カテゴリの言語機構を分類したものではありません。
「抽象的な操作を利用する計算を、具体的な意味から切り離してどのように表現し、後から意味付けするか」という共通の設計問題に対する、異なるアプローチを比較しています。
操作は副作用に限定されません。この題材の`discountAmount`と`shippingFee`は、純粋な計算として扱います。
各言語はそのアプローチを簡潔・自然に示すための例であり、その言語固有の方式だという意味ではありません。

共通題材では、`subtotal = 3000` に対して割引額を小計の10%（`300`）、送料を`500`として、
`subtotal - discountAmount subtotal + shippingFee subtotal` により合計額`3200`を求めます。

```text
3200
```

## プロジェクト構成

各言語は、その言語の標準的なビルドツールで独立して管理します。

| 方式 | 言語 | プロジェクト管理 | 実行コマンド |
| --- | --- | --- | --- |
| インターフェース＋実装 | Scala | sbt | `cd scala && sbt run` |
| 関数の受け渡し | F# | .NET SDK | `cd fsharp && dotnet run` |
| 型クラスを使った抽象的な計算 | Haskell | Stack | `cd haskell && stack exec type-class` |
| Freeモナド | Haskell | Stack + free | `cd haskell && stack exec free-monad` |
| Extensible Effects | Haskell | Stack + freer-simple | `cd haskell && stack exec extensible-effects` |
| Algebraic Effects & Handlers | Koka | Koka module | `cd koka && make run` |

HaskellのFreeモナドは、自前実装ではなく
[`free`](https://hackage.haskell.org/package/free) 5.2を使用します。
Extensible Effectsも自前の符号化ではなく
[`freer-simple`](https://hackage.haskell.org/package/freer-simple) 1.2.1.2を使用します。

## 必要なツール

- JDK（sbt用）
- .NET SDK 8.0（F#用）
- Stack
- Cコンパイラ（Koka用）
- `make`

`scripts/bootstrap-tools.sh` は、sbt、.NET SDK、Kokaを
プロジェクト内の `.tools/` に導入します。DuneとStackはシステムの標準的な導入方法で用意してください。

```sh
./scripts/bootstrap-tools.sh
make verify
./scripts/verify.sh
```

`make verify` は各プロジェクトの標準コマンドを通じて、6アプローチの共通サンプルに加え、Kokaの制御フローの補助例もビルド・実行します。
`scripts/verify.sh` は、6つの共通サンプルが`3200`を返すことに加え、Kokaの補助例で`stop`より後の処理が実行されないことも検査します。

Kokaの制御フローの補助例だけを実行する場合は、次を実行します。

```sh
cd koka
make control-example
```
