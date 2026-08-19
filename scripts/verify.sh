#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"

mkdir -p .build
log_file=.build/verify.log

if ! make verify >"$log_file" 2>&1; then
  cat "$log_file"
  exit 1
fi

cat "$log_file"

expected='log: greeted Ada
Hello, Ada!'

for line in 'log: greeted Ada' 'Hello, Ada!'; do
  count=$(grep -Fxc "$line" "$log_file" || true)
  if [ "$count" -ne 9 ]; then
    printf 'expected %s occurrences of %s, got %s\n' 9 "$line" "$count" >&2
    exit 1
  fi
done

printf 'verified: all nine samples produced the expected output\n'
