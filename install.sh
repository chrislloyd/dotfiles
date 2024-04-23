#!/usr/bin/env bash
set -euo pipefail

DOTFILES=$(cd "$(dirname "$0")"; pwd)
readonly DOTFILES
export DOTFILES
pushd "$PWD"
cd

# shell
ln -s -f "$DOTFILES/.inputrc" .
ln -s -f "$DOTFILES/.profile" .

# bash
ln -s -f "$DOTFILES/.bash_profile" .
ln -s -f "$DOTFILES/.bashrc" .

# zsh
ln -s -f "$DOTFILES/.zshrc" .

# ssh
mkdir -p .ssh
mkdir -p .ssh/config.d
ln -s -f "$DOTFILES/.ssh/config" .ssh

# editorconfig
ln -s -f "$DOTFILES/.editorconfig" .

# git
ln -s -f "$DOTFILES/.gitconfig" .
ln -s -f "$DOTFILES/.gitignore" .
ln -s -f "$DOTFILES/.gitmessage" .

# zgen
if [ ! -d "${HOME}/.zgen" ]
then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# bin
mkdir -p bin
ln -s -f "$DOTFILES/bin"/* bin

# developer
mkdir -p src

# platform-specific
if [ "$(uname)" == "Darwin" ]
then
    "$DOTFILES"/macos.sh
else
    "$DOTFILES"/linux.sh
fi

popd
