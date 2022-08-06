#!/usr/bin/env bash
set -euo pipefail

DOTFILES=$(cd "$(dirname "$0")"; pwd)
readonly DOTFILES
pushd "$PWD"
cd

# config
mkdir -p .config

# bash
ln -s -f "$DOTFILES/bash/.bash_profile" .
ln -s -f "$DOTFILES/bash/.bashrc" .

# ssh
mkdir -p .ssh
mkdir -p .ssh/config.d
ln -s -f "$DOTFILES/ssh/config" .ssh

# editorconfig
ln -s -f "$DOTFILES/editorconfig/.editorconfig" .

# emacs
ln -s -f "$DOTFILES/emacs/.emacs.d" .

# git
cp "$DOTFILES/git/.gitconfig" .
ln -s -f "$DOTFILES/git/.global.gitconfig" .
ln -s -f "$DOTFILES/git/.gitignore" .
ln -s -f "$DOTFILES/git/.gitmessage" .

# shell
touch .hushlogin
mkdir -p bin
mkdir -p src
ln -s -f "$DOTFILES/shell/.inputrc" .
ln -s -f "$DOTFILES/shell/.profile" .

# zsh
ln -s -f "$DOTFILES/zsh/.zprofile" .
ln -s -f "$DOTFILES/zsh/.zshrc" .

# zgen
if [ ! -d "${HOME}/.zgen" ]
then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# xcode
if [ "$(uname)" == "Darwin" ] && [ ! "$(xcode-select -p 1>/dev/null;echo $?)" ]
then
  sudo xcode-select --install
fi

# homebrew
if [ "$(uname)" == "Darwin" ]
then
  if ! command -v brew > /dev/null
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ln -s -f "$DOTFILES/homebrew/Brewfile" .Brewfile
  brew bundle --no-upgrade --global
fi

popd
