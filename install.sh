#!/usr/bin/env bash
set -euo pipefail

DOTFILES=$(cd "$(dirname "$0")"; pwd)
readonly DOTFILES
export DOTFILES
pushd "$PWD"
trap popd EXIT

link() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    echo "Error: $source does not exist"
    return 1
  fi

  if [ -L "$target" ]; then
    return 0
  elif [ -e "$target" ]; then
    echo "Error: $target already exists and is not a symlink"
    return 1
  else
    ln -sF "$source" "$target"
  fi
}

# --

cd

# shell
link "$DOTFILES/.inputrc" .inputrc
link "$DOTFILES/.profile" .profile

# bash
link "$DOTFILES/.bash_profile" .bash_profile
link "$DOTFILES/.bashrc" .bashrc

# zsh
link "$DOTFILES/.zshrc" .zshrc

# ssh
mkdir -p .ssh
mkdir -p .ssh/config.d
link "$DOTFILES/.ssh/config" .ssh/config

# editorconfig
link "$DOTFILES/.editorconfig" .editorconfig

# git
# .gitconfig is NOT symlinked - it's local so `git config --global` works
if [ ! -e .gitconfig ]; then
  echo "[include]\n    path = $DOTFILES/.gitconfig.shared" > .gitconfig
fi
link "$DOTFILES/.gitignore" .gitignore
link "$DOTFILES/.gitmessage" .gitmessage

# bin
link "$DOTFILES/bin" bin

# developer
mkdir -p code

# config
mkdir -p .config
for item in "$DOTFILES"/.config/*; do
  name=$(basename "$item")
  [ "$name" = "atuin" ] && continue
  [ -e "$item" ] && link "$item" ".config/$name"
done

# atuin (has runtime state, only symlink config)
mkdir -p .config/atuin
link "$DOTFILES/.config/atuin/config.toml" .config/atuin/config.toml

# claude
mkdir -p .claude
link "$DOTFILES/.claude/CLAUDE.md" .claude/CLAUDE.md
link "$DOTFILES/.claude/settings.local.json" .claude/settings.local.json

# platform-specific
if [ "$(uname)" == "Darwin" ]
then
    "$DOTFILES"/macos.sh
else
    "$DOTFILES"/linux.sh
fi
