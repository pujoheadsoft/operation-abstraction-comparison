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

total_count=$(grep -Fxc '3200' "$log_file" || true)
if [ "$total_count" -ne 6 ]; then
  printf 'expected %s occurrences of the total 3200, got %s\n' 6 "$total_count" >&2
  exit 1
fi

control_before_count=$(grep -Fxc 'before' "$log_file" || true)
if [ "$control_before_count" -ne 1 ]; then
  printf 'expected the Koka control example to print before once, got %s\n' "$control_before_count" >&2
  exit 1
fi

if grep -Fxq 'after' "$log_file"; then
  printf 'the Koka control example resumed its continuation unexpectedly\n' >&2
  exit 1
fi

printf 'verified: all six common samples and the Koka control example passed\n'
