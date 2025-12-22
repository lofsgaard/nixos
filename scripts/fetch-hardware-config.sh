#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/fetch-hardware-config.sh <hostname>

HOSTNAME="${1:-}"

if [ -z "$HOSTNAME" ]; then
  echo "Usage: $0 <hostname>"
  echo "Example: $0 valhalla"
  exit 1
fi

HOST_DIR="hosts/$HOSTNAME"

# Check if host exists
if [ ! -d "$HOST_DIR" ]; then
  echo "Error: Host $HOSTNAME does not exist in $HOST_DIR"
  exit 1
fi

# Get the hostname/IP from deploy config in flake.nix
# For now, we'll ask the user to provide it
read -p "Enter hostname or IP for $HOSTNAME: " TARGET

echo "Fetching hardware-configuration.nix from $TARGET..."

# SSH into the remote host and generate hardware config
ssh "fjs@$TARGET" "sudo nixos-generate-config --show-hardware-config" > "$HOST_DIR/hardware-configuration.nix"

echo "✓ Hardware configuration saved to $HOST_DIR/hardware-configuration.nix"
echo ""
echo "Review the file and commit it to git:"
echo "  git add $HOST_DIR/hardware-configuration.nix"
echo "  git commit -m 'feat: add hardware config for $HOSTNAME'"
