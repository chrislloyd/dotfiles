#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "* $1"
}

log "Cleaning screenshots"
readonly dir="$HOME/Screenshots"
mkdir -p "$dir"
mv "$HOME/Desktop"/Screen*.png "$dir"
