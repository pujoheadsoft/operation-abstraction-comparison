#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
mkdir -p .tools/bin .tools/downloads .tools/koka

download() {
  destination=$1
  url=$2
  if [ ! -f "$destination" ]; then
    curl -fL --retry 2 -o "$destination" "$url"
  fi
}

if [ ! -x .tools/sbt/bin/sbt ]; then
  download .tools/downloads/sbt-1.12.14.tgz \
    https://github.com/sbt/sbt/releases/download/v1.12.14/sbt-1.12.14.tgz
  tar -xzf .tools/downloads/sbt-1.12.14.tgz -C .tools
fi

if [ ! -x .tools/dotnet/dotnet ]; then
  download .tools/downloads/dotnet-install.sh \
    https://dot.net/v1/dotnet-install.sh
  bash .tools/downloads/dotnet-install.sh \
    --channel 8.0 \
    --install-dir "$root/.tools/dotnet" \
    --no-path
fi

if [ ! -x .tools/clojure/bin/clojure ]; then
  download .tools/downloads/linux-install-1.12.5.1654.sh \
    https://download.clojure.org/install/linux-install-1.12.5.1654.sh
  install_temp_dir=$(mktemp -d)
  (
    cd "$install_temp_dir"
    bash "$root/.tools/downloads/linux-install-1.12.5.1654.sh" --prefix "$root/.tools/clojure"
  )
  rmdir "$install_temp_dir"
fi

if [ ! -x .tools/koka/bin/koka ]; then
  download .tools/downloads/koka-v3.2.3-linux-x64.tar.gz \
    https://github.com/koka-lang/koka/releases/download/v3.2.3/koka-v3.2.3-linux-x64.tar.gz
  tar -xzf .tools/downloads/koka-v3.2.3-linux-x64.tar.gz -C .tools/koka
fi
