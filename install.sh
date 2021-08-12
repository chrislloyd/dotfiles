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

function gnu-stow() {
  case $(uname -s) in
    Linux*)
      apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install stow
      ;;
    Darwin*)
      if ! command -v stow > /dev/null; then
        brew install stow
      fi
      ;;
  esac

  stow --verbose --restow bash editorconfig emacs git shell zsh
}

# Install dependencies
install "zgen" zgen
install "XCode" xcode
install "homebrew" homebrew
install "stow" gnu-stow
