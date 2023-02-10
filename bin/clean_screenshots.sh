#!/usr/bin/env bash
set -euo pipefail

readonly dir="$HOME/screenshots"

mkdir -p "$dir"
mv "$HOME/Desktop"/Screen*.png "$dir"
