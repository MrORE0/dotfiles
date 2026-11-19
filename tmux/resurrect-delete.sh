#!/usr/bin/env bash
RESURRECT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"

entries=$(
  for f in $(ls -t "$RESURRECT_DIR"/tmux_resurrect_*.txt 2>/dev/null); do
    timestamp=$(basename "$f" | sed 's/tmux_resurrect_//;s/\.txt$//')
    sessions=$(grep "^pane" "$f" | awk '{print $2}' | sort -u | tr '\n' ',' | sed 's/,$//')
    echo "$timestamp  [$sessions]  $(basename "$f")"
  done | fzf --prompt="Delete saves (tab to multi-select): " --height=40% --reverse \
             --no-sort --multi --delimiter="  " --with-nth=1,2
)

[[ -z "$entries" ]] && exit 0

current_last=$(readlink "$RESURRECT_DIR/last" 2>/dev/null | xargs basename 2>/dev/null)

while IFS= read -r entry; do
  filename=$(echo "$entry" | awk '{print $NF}')
  rm -f "$RESURRECT_DIR/$filename"
  [[ "$filename" == "$current_last" ]] && relink=1
done <<< "$entries"

if [[ -n "$relink" ]]; then
  newest=$(ls -t "$RESURRECT_DIR"/tmux_resurrect_*.txt 2>/dev/null | head -1)
  [[ -n "$newest" ]] && ln -sf "$newest" "$RESURRECT_DIR/last" || rm -f "$RESURRECT_DIR/last"
fi
