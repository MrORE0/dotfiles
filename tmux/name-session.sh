#!/usr/bin/env bash
# Rename an auto-numbered session after its directory, adding a suffix only if that name is taken.
id="$1"; name="$2"; dir="$3"
[[ "$name" =~ ^[0-9]+$ ]] || exit 0
base=$(basename "$dir" | tr '.:' '__')
candidate="$base"; n=2
while tmux has-session -t "=$candidate" 2>/dev/null; do
  candidate="$base-$n"; n=$((n + 1))
done
tmux rename-session -t "$id" "$candidate"
