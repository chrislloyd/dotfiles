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

function vscode() {
  if [ "$(uname)" != "Darwin" ]; then
    return
  fi

  if [ ! -e "/Applications/Visual Studio Code.app" ]; then
    brew cask install visual-studio-code
  fi

  mkdir -p "$HOME/Library/Application Support/Code/User"

  if [ "$TERM_PROGRAM" = "vscode" ]; then
    skip
  fi

  code --install-extension github.github-vscode-theme
  code --install-extension github.vscode-pull-request-github
  code --install-extension lfs.vscode-emacs-friendly
  code --install-extension ms-vscode-remote.vscode-remote-extensionpack
}

function gnu-stow() {
  case $(uname -s) in
    Linux*)
      sudo apt install stow
      ;;
    Darwin*)
      if ! command -v stow > /dev/null; then
        brew install stow
      fi

      stow --verbose --restow vscode --target "$HOME/Library/Application Support/Code/User"
      ;;
  esac

  stow --verbose --restow bash editorconfig emacs git shell zsh
}

# Install dependencies
install "zgen" zgen
install "XCode" xcode
install "homebrew" homebrew
install "VSCode" vscode
install "stow" gnu-stow
