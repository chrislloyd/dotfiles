#!/usr/bin/env bash
set -euo pipefail

function skip() {
  echo "Skipping:" $@
}

function install_zgen() {
	if [ -d "${HOME}/.zgen" ]; then
    skip "zgen"
    return
	fi

  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
}

function install_xcode() {
  if [ ! "$(uname)" == "Darwin" ] || [ $(xcode-select -p 1>/dev/null;echo $?) ]; then
    skip "XCode"
    return
  fi

  sudo xcode-select --install
}

function install_homebrew() {
  if [ ! "$(uname)" == "Darwin" ]; then
    skip "Homebrew"
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
      target="$HOME/Library/Application Support/Code/User"
      ;;
    *)
      return
      ;;
  esac

  mkdir -p "$target"
  stow vscode --target "$target"

  if [ "$TERM_PROGRAM" == "vscode" ]; then
    skip "VSCode extensions"
    return
  fi
  
  code --install-extension github.github-vscode-theme
  code --install-extension github.vscode-pull-request-github
  code --install-extension editorconfig.editorconfig
  code --install-extension lfs.vscode-emacs-friendly
  code --install-extension ms-vscode-remote.vscode-remote-extensionpack
}

install_zgen
install_homebrew
install_vscode

stow --verbose --restow bash editorconfig emacs git shell zsh
