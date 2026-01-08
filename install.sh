#!/bin/sh
set -e

# Install Nix if not present
if ! command -v nix >/dev/null 2>&1; then
  echo "Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  echo "Please restart your shell and run this script again."
  exit 0
fi

# Source nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Install/update nix-darwin and home-manager config
echo "Building and activating nix-darwin configuration..."
sudo nix run nix-darwin -- switch --flake ~/dotfiles#"$(hostname -s)"

echo "Done! Open a new terminal to use the new configuration."
