#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/bootstrap-host.sh <hostname> <ip-address>

HOSTNAME="${1:-}"
IP="${2:-}"

if [ -z "$HOSTNAME" ] || [ -z "$IP" ]; then
  echo "Usage: $0 <hostname> <ip-address>"
  echo "Example: $0 valhalla 192.168.1.100"
  exit 1
fi

HOST_DIR="hosts/$HOSTNAME"

# Check if host already exists
if [ -d "$HOST_DIR" ]; then
  echo "Error: Host $HOSTNAME already exists in $HOST_DIR"
  exit 1
fi

echo "Creating new host: $HOSTNAME at $IP"
echo "==================================="

# 1. Copy template
echo "Step 1: Copying template..."
cp -r hosts/_template "$HOST_DIR"

# 2. Customize hostname in configuration.nix
echo "Step 2: Setting hostname..."
sed -i "s/HOSTNAME/$HOSTNAME/g" "$HOST_DIR/configuration.nix"

# 3. Instructions
echo ""
echo "✓ Host configuration created in $HOST_DIR"
echo ""
echo "Next steps:"
echo "1. Review and customize $HOST_DIR/configuration.nix"
echo "2. Check disk device in $HOST_DIR/disko.nix (default: /dev/sda)"
echo "3. Add SSH key to $HOST_DIR/configuration.nix if different"
echo "4. Add to flake.nix:"
echo ""
echo "   nixosConfigurations.$HOSTNAME = nixpkgs.lib.nixosSystem {"
echo "     modules = ["
echo "       disko.nixosModules.disko"
echo "       ./hosts/$HOSTNAME/configuration.nix"
echo "     ];"
echo "   };"
echo ""
echo "   deploy.nodes.$HOSTNAME = {"
echo "     hostname = \"$IP\";  # or use FQDN"
echo "     profiles.system = {"
echo "       sshUser = \"fjs\";"
echo "       user = \"root\";"
echo "       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.$HOSTNAME;"
echo "     };"
echo "   };"
echo ""
echo "5. Run nixos-anywhere:"
echo "   nix run github:nix-community/nixos-anywhere -- --flake .#$HOSTNAME root@$IP"
echo ""
echo "6. Fetch the generated hardware-configuration.nix:"
echo "   fetch-hardware-config $HOSTNAME"
echo "   (or: ./scripts/fetch-hardware-config.sh $HOSTNAME)"
echo ""
echo "7. Review and commit the hardware config:"
echo "   git add $HOST_DIR/hardware-configuration.nix"
echo "   git commit -m 'feat: add hardware config for $HOSTNAME'"
echo ""
echo "8. After installation, manage with deploy-rs:"
echo "   deploy .#$HOSTNAME"
echo ""
