#!/usr/bin/env bash
set -euo pipefail

function install() {
  echo "Installing $1..."
  ($2)
}

function skip() {
  echo "Skipping"
}

function zgen() {
	if [ -d "${HOME}/.zgen" ]; then
    skip
    return
	fi

  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
}

function xcode() {
  if [ "$(uname)" != "Darwin" ] || [ $(xcode-select -p 1>/dev/null;echo $?) ]; then
    skip
    return
  fi

  sudo xcode-select --install
}

function homebrew() {
  if [ "$(uname)" != "Darwin" ]; then
    skip
    return
  fi

  if ! command -v brew > /dev/null; then
    CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  brew bundle --file homebrew/.Brewfile
}

# Install dependencies
install "zgen" zgen
install "XCode" xcode
install "homebrew" homebrew

__dirname=$(cd $(dirname $0); pwd)
pushd $PWD
cd

# bash
ln -s -f $__dirname/bash/.bash_profile .
ln -s -f $__dirname/bash/.bashrc .

# editorconfig
ln -s -f $__dirname/editorconfig/.editorconfig .

# emacs
ln -s -f $__dirname/emacs/.emacs.d .

# git
ln -s -f $__dirname/git/.gitconfig .
ln -s -f $__dirname/git/.gitignore .
ln -s -f $__dirname/git/.gitmessage .

# shell
touch .hushlogin
ln -s -f $__dirname/shell/.inputrc .
ln -s -f $__dirname/shell/.profile .

# zsh
ln -s -f $__dirname/zsh/.zprofile .
ln -s -f $__dirname/zsh/.zshrc .

popd
