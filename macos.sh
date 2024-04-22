#!/usr/bin/env bash
set -euo pipefail

# shell
touch .hushlogin

# xcode
if [ ! "$(xcode-slect -p 1>/dev/null;echo $?)" ]
then
    sudo xcode-select --install
fi

# homebrew
if ! command -v brew > /dev/null
then
  if ! command -v brew > /dev/null
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew analytics off
  ln -s -f "$DOTFILES/.Brewfile" .
  brew bundle --no-upgrade --global || true
fi

# launchd
ln -s -f "$DOTFILES/LaunchAgents"/*.plist Library/LaunchAgents
