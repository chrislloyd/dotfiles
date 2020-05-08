#!/usr/bin/env bash
set -euo pipefail

function install_homebrew() {
    if [ ! "$(uname)" == "Darwin" ]; then
        return
    fi
    CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    stow homebrew
    brew bundle --global
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
    code --install-extension editorconfig.editorconfig
    code --install-extension hiro-sun.vscode-emacs
}

# install_homebrew
install_vscode

stow bash
stow editorconfig
stow emacs
stow git
stow shell
stow zsh
