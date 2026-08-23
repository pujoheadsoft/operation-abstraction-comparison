ROOT := $(abspath .)
SBT := $(ROOT)/.tools/sbt/bin/sbt
DOTNET := $(ROOT)/.tools/dotnet/dotnet
KOKA := $(ROOT)/.tools/koka/bin/koka
SBT_OPTS := -Dsbt.global.base=$(ROOT)/.tools/sbt-global -Dsbt.boot.directory=$(ROOT)/.tools/sbt-boot -Dsbt.ivy.home=$(ROOT)/.tools/ivy2 -Dcoursier.cache=$(ROOT)/.tools/coursier
STACK_ROOT := $(ROOT)/.tools/stack
SPAGO_CACHE := $(ROOT)/.tools/xdg-cache
SPAGO_CONFIG := $(ROOT)/.tools/xdg-config

.PHONY: verify scala fsharp haskell purescript koka

verify: scala fsharp haskell purescript koka

scala:
	cd scala && COURSIER_CACHE=$(ROOT)/.tools/coursier SBT_OPTS="$(SBT_OPTS)" $(SBT) --batch run

fsharp:
	$(DOTNET) run --project fsharp/FunctionPassing.fsproj

haskell:
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack build
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack exec type-class
	cd haskell && STACK_ROOT=$(STACK_ROOT) stack exec extensible-effects

purescript:
	cd purescript && XDG_CACHE_HOME=$(SPAGO_CACHE) XDG_CONFIG_HOME=$(SPAGO_CONFIG) spago build
	cd purescript && node run.mjs

koka:
	cd koka && $(MAKE) KOKA=$(KOKA) run
	cd koka && $(MAKE) KOKA=$(KOKA) control-example
