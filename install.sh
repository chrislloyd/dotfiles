#!/usr/bin/env bash
set -euo pipefail

function install_zgen() {
	if [ -d "${HOME}/.zgen" ]; then
    return
	fi

  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
}

function install_xcode() {
  if [ ! "$(uname)" == "Darwin" ]; then
    return
  fi

  if [ $(xcode-select -p 1>/dev/null;echo $?) ]; then
    return
  fi

  sudo xcode-select --install
}

function install_homebrew() {
  if [ ! "$(uname)" == "Darwin" ]; then
    return
  fi

  CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew bundle --file homebrew/.Brewfile
  stow homebrew
}

function install_vscode() {
  case $(uname -s) in
    Linux*)
      target="$HOME/.config/Code/User"
      ;;
    Darwin*)
      stow vscode --target "$HOME/Library/Application Support/Code/User"
      ;;
    *)
  esac

  code --install-extension github.github-vscode-theme
  code --install-extension github.vscode-pull-request-github
  code --install-extension editorconfig.editorconfig
  code --install-extension lfs.vscode-emacs-friendly
  code --install-extension ms-vscode-remote.vscode-remote-extensionpack
}

install_zgen
install_xcode
install_homebrew
install_vscode

stow --verbose --restow bash editorconfig emacs git shell zsh
