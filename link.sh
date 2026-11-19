#!/usr/bin/env bash
# Symlink the configs in this repo into place. Existing files are moved to *.backup-<timestamp>.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "$dest.backup-$STAMP"
    echo "backed up $dest"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest"
}

link zsh/zshrc                 "$HOME/.zshrc"
link zsh/zprofile              "$HOME/.zprofile"
link zsh/zshenv                "$HOME/.zshenv"
link tmux/tmux.conf            "$HOME/.tmux.conf"
link tmux/name-session.sh      "$HOME/.tmux/name-session.sh"
link tmux/resurrect-picker.sh  "$HOME/.tmux/resurrect-picker.sh"
link tmux/resurrect-delete.sh  "$HOME/.tmux/resurrect-delete.sh"
link git/gitconfig             "$HOME/.gitconfig"
link git/ignore                "$HOME/.config/git/ignore"
link ghostty/config.ghostty    "$HOME/.config/ghostty/config.ghostty"
link ghostty/themes            "$HOME/.config/ghostty/themes"

# iTerm2 reads its preferences from this repo
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
