# dotfiles

Terminal setup for macOS: zsh (Oh My Zsh), tmux, git, Ghostty, iTerm2 and Homebrew packages.

## New machine

```sh
git clone https://github.com/MrORE0/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` installs Homebrew and everything in `Brewfile`, Oh My Zsh, tmux plugins (tpm),
clones the Neovim config, and symlinks the configs below. It is safe to rerun.

To only relink configs: `~/dotfiles/link.sh`. 
Files it replaces are kept as `*.backup-<timestamp>`.

## Layout

| Repo path | Linked to |
| --- | --- |
| `zsh/zshrc`, `zsh/zprofile`, `zsh/zshenv` | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `tmux/tmux.conf`, `tmux/*.sh` | `~/.tmux.conf`, `~/.tmux/*.sh` |
| `git/gitconfig`, `git/ignore` | `~/.gitconfig`, `~/.config/git/ignore` |
| `ssh/config` | `~/.ssh/config` |
| `ghostty/` | `~/.config/ghostty/` |
| `iterm2/` | iTerm2 loads preferences from this folder |
| `Brewfile` | `brew bundle` |

## Updating

Edits to linked files land in the repo directly; commit them. Refresh the package list with
`brew bundle dump --file=~/dotfiles/Brewfile --force`.
