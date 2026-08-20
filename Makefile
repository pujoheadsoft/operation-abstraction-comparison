ROOT := $(abspath .)
SBT := $(ROOT)/.tools/sbt/bin/sbt
DOTNET := $(ROOT)/.tools/dotnet/dotnet
CLOJURE := $(ROOT)/.tools/clojure/bin/clojure
KOKA := $(ROOT)/.tools/koka/bin/koka
SBT_OPTS := -Dsbt.global.base=$(ROOT)/.tools/sbt-global -Dsbt.boot.directory=$(ROOT)/.tools/sbt-boot -Dsbt.ivy.home=$(ROOT)/.tools/ivy2 -Dcoursier.cache=$(ROOT)/.tools/coursier
STACK_ROOT := $(ROOT)/.tools/stack
CLJ_CONFIG := $(ROOT)/.tools/clojure-config

.PHONY: verify scala fsharp ocaml haskell clojure koka

verify: scala fsharp ocaml haskell clojure koka

scala:
	cd scala && COURSIER_CACHE=$(ROOT)/.tools/coursier SBT_OPTS="$(SBT_OPTS)" $(SBT) --batch run

fsharp:
	$(DOTNET) run --project fsharp/FunctionPassing.fsproj

ocaml:
	cd ocaml && dune exec ./bin/structural.exe
	cd ocaml && dune exec ./bin/module_parameter.exe

haskell:
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack build
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack exec type-class
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack exec free-monad
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack exec extensible-effects

clojure:
	cd clojure && CLJ_CONFIG=$(CLJ_CONFIG) $(CLOJURE) -M:run

koka:
	cd koka && $(MAKE) KOKA=$(KOKA) run
	cd koka && $(MAKE) KOKA=$(KOKA) control-example
