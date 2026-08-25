# 操作の抽象化の比較: 実行可能なコード例

関数型プログラミングにおける6つのアプローチを、同じ題材で比較するための実行可能なサンプルです。

ここでの6つは、同一カテゴリの言語機構を分類したものではありません。
「抽象的な操作を利用する計算を、具体的な意味から切り離してどのように表現し、後から意味付けするか」という共通の設計問題に対する、異なるアプローチを比較しています。
操作は副作用に限定されません。この題材の製造コストは純粋な計算として扱います。
各言語はそのアプローチを簡潔・自然に示すための例であり、その言語固有の方式だという意味ではありません。

## 共通題材

基本例では、`ManufacturingCost`という操作群に`materialCost`と`assemblyCost`を定義します。
`calculateTotalCost quantity`は、材料費と組立費の合計を求めます。

- `materialCost quantity = quantity * 100`
- `assemblyCost quantity = quantity * 50`

`quantity = 10`の結果は`1500`です。

拡張例では、独立した操作群`PackagingCost`と、その操作`packagingCost`を既存の計算へ追加します。

- `packagingCost quantity = quantity * 20`

拡張後も計算の名前は`calculateTotalCost`であり、`quantity = 10`の結果は`1700`です。
basicとextendedを別ファイルまたは別モジュールに分けることで、同じ計算に新しい操作の要求が加わったことを比較できます。

```text
1500
1700
```

## プロジェクト構成

各言語は、その言語の標準的なビルドツールで独立して管理します。

| 方式 | 言語 | プロジェクト管理 | 実行コマンド |
| --- | --- | --- | --- |
| インターフェース＋実装 | Scala | sbt | `cd scala && sbt run` |
| 関数の受け渡し | F# | .NET SDK | `cd fsharp && dotnet run` |
| 型クラス＋Tagless Final | Haskell | Stack | `cd haskell && stack exec type-class && stack exec type-class-extended` |
| Freeモナド | PureScript | Spago + purescript-free | `cd purescript && spago build && node run.mjs` |
| Extensible Effects | Haskell | Stack + freer-simple | `cd haskell && stack exec extensible-effects && stack exec extensible-effects-extended` |
| Algebraic Effects & Handlers | Koka | Koka module | `cd koka && make run && make extended` |

| 方式 | basic | extended |
| --- | --- | --- |
| インターフェース＋実装 | `scala/src/main/scala/operationabstraction/scalaexample/Basic.scala` | `scala/src/main/scala/operationabstraction/scalaexample/Extended.scala` |
| 関数の受け渡し | `fsharp/Basic.fs` | `fsharp/Extended.fs` |
| 型クラス＋Tagless Final | `haskell/src/TypeClass.hs` | `haskell/src/TypeClassExtended.hs` |
| Freeモナド | `purescript/src/Basic.purs` | `purescript/src/Extended.purs` |
| Extensible Effects | `haskell/src/ExtensibleEffects.hs` | `haskell/src/ExtensibleEffectsExtended.hs` |
| Algebraic Effects & Handlers | `koka/src/main.kk` | `koka/src/extended.kk` |

PureScriptのFreeモナドは、命令型自身の`Functor` instanceを書かずに利用できる
[`purescript-free`](https://pursuit.purescript.org/packages/purescript-free) 7.1.0を使用します。
Extensible Effectsも自前の符号化ではなく
[`freer-simple`](https://hackage.haskell.org/package/freer-simple) 1.2.1.2を使用します。

## 必要なツール

- JDK（sbt用）
- .NET SDK 8.0（F#用）
- PureScript 0.15.15 / Spago / Node.js
- Stack
- Cコンパイラ（Koka用）
- `make`

`scripts/bootstrap-tools.sh`は、sbt、.NET SDK、Kokaを
プロジェクト内の`.tools/`に導入します。Stack、PureScript、Spago、Node.jsはシステムの標準的な導入方法で用意してください。

```sh
./scripts/bootstrap-tools.sh
make verify
./scripts/verify.sh
```

`make verify`は、6方式それぞれのbasicとextendedに加え、Kokaの制御フローの補助例もビルド・実行します。
`scripts/verify.sh`は、6つのbasicが`1500`、6つのextendedが`1700`を返すことに加え、Kokaの補助例で`stop`より後の処理が実行されないことも検査します。

Kokaの制御フローの補助例だけを実行する場合は、次を実行します。

```sh
cd koka
make control-example
```
