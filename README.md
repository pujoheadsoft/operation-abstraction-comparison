# 操作の抽象化の比較: 実行可能なコード例

関数型プログラミングにおける9つの操作抽象化方式を、同じ題材で比較するための実行可能なサンプルです。
すべての例で、`greet userId` は名前を取得し、挨拶を記録してから挨拶文を返します。

```text
log: greeted Ada
Hello, Ada!
```

## プロジェクト構成

各言語は、その言語の標準的なビルドツールで独立して管理します。

| 方式 | 言語 | プロジェクト管理 | 実行コマンド |
| --- | --- | --- | --- |
| インターフェース＋実装 | Scala | sbt | `cd scala && sbt run` |
| 関数群の受け渡し | F# | .NET SDK | `cd fsharp && dotnet run` |
| 構造による操作の要求 | OCaml | Dune | `cd ocaml && dune exec ./bin/structural.exe` |
| 型クラス | Haskell | Stack | `cd haskell && stack exec type-class` |
| モジュールによるパラメータ化 | OCaml | Dune | `cd ocaml && dune exec ./bin/module_parameter.exe` |
| マルチメソッド／多重ディスパッチ | Clojure | Clojure CLI | `cd clojure && clojure -M:run` |
| Freeモナド | Haskell | Stack + free | `cd haskell && stack exec free-monad` |
| Extensible Effects | Haskell | Stack + freer-simple | `cd haskell && stack exec extensible-effects` |
| Algebraic Effects & Handlers | Koka | Koka module | `cd koka && make run` |

HaskellのFreeモナドは、自前実装ではなく
[`free`](https://hackage.haskell.org/package/free) 5.2を使用します。
Extensible Effectsも自前の符号化ではなく
[`freer-simple`](https://hackage.haskell.org/package/freer-simple) 1.2.1.2を使用します。

## 必要なツール

- JDK（sbtおよびClojure CLI用）
- .NET SDK 8.0（F#用）
- Dune / OCaml
- Stack
- Cコンパイラ（Koka用）
- `make`

`scripts/bootstrap-tools.sh` は、sbt、.NET SDK、Clojure CLI、Kokaを
プロジェクト内の `.tools/` に導入します。DuneとStackはシステムの標準的な導入方法で用意してください。

```sh
./scripts/bootstrap-tools.sh
make verify
./scripts/verify.sh
```

`make verify` は各プロジェクトの標準コマンドを通じて、9方式の共通サンプルに加え、Kokaの制御フローの補助例もビルド・実行します。
`scripts/verify.sh` は、9つの共通サンプルが想定した出力を返すことに加え、Kokaの補助例で`stop`より後の処理が実行されないことも検査します。

Kokaの制御フローの補助例だけを実行する場合は、次を実行します。

```sh
cd koka
make control-example
```
