#!/usr/bin/env bash
RESURRECT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"

entry=$(
  for f in $(ls -t "$RESURRECT_DIR"/tmux_resurrect_*.txt 2>/dev/null); do
    timestamp=$(basename "$f" | sed 's/tmux_resurrect_//;s/\.txt$//')
    sessions=$(grep "^pane" "$f" | awk '{print $2}' | sort -u | tr '\n' ',' | sed 's/,$//')
    echo "$timestamp  [$sessions]  $(basename "$f")"
  done | fzf --prompt="Restore session: " --height=40% --reverse --no-sort \
             --delimiter="  " --with-nth=1,2
)

[[ -z "$entry" ]] && exit 0

filename=$(echo "$entry" | awk '{print $NF}')
ln -sf "$RESURRECT_DIR/$filename" "$RESURRECT_DIR/last"
~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
