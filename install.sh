#!/usr/bin/env bash
set -euo pipefail

# Install dependencies
case $(uname -s) in
    Linux*)
        ;;
    Darwin*)
        # CI=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # brew bundle --file homebrew/.Brewfile
        ;;
    *)
esac

# Stow configs
for dir in */
do
    stow ${dir%*/}
done
