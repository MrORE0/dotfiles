#!/usr/bin/env bash
# Bootstrap a new Mac: Homebrew, packages, Oh My Zsh, tmux plugins, Neovim config, then symlinks.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish installing the Xcode Command Line Tools, then run this script again."
  exit 1
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file="$DOTFILES/Brewfile" || echo "Some Brewfile entries failed; rerun 'brew bundle' later."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [[ ! -d "$HOME/.config/nvim" ]]; then
  git clone https://github.com/MrORE0/nvim-conf.git "$HOME/.config/nvim"
fi

"$DOTFILES/link.sh"

GIT_CONFIG_GLOBAL=/dev/null "$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo "Done. Open a new terminal. Put machine-specific settings in ~/.zshrc.local and ~/.gitconfig.local."
