# NixOS Configuration

A declarative, flake-based NixOS configuration managing multiple systems with shared modules and host-specific configurations.

## Hosts

### Bifrost (Desktop Workstation)
- **Type**: Desktop workstation
- **Window Manager**: i3
- **User Management**: home-manager
- **GPU**: NVIDIA
- **Primary Use**: Development and gaming

### Asgard (Remote Server)
- **Type**: Remote server
- **Location**: Europe/Falkenstein
- **Primary Use**: Web services with Traefik reverse proxy
- **Deployment**: deploy-rs
- **Secrets**: agenix

## Quick Start

### Bifrost (Desktop)

```bash
# Rebuild and switch
sudo nixos-rebuild switch --flake ~/nixos#bifrost
# Or use alias
nrs

# Test without persisting
nrt

# Rebuild with flake updates
nru
```

### Asgard (Server)

```bash
# Deploy from local machine
deploy .#asgard

# Or rebuild on server
sudo nixos-rebuild switch --flake /etc/nixos#asgard
```

## Project Structure

```
.
├── flake.nix                    # Flake inputs and host configurations
├── flake.lock                   # Locked dependency versions
├── CLAUDE.md                    # AI assistant guidance
│
├── hosts/                       # Host-specific configurations
│   ├── bifrost/
│   │   ├── configuration.nix    # System configuration
│   │   ├── home.nix            # Home-manager config
│   │   └── hardware-configuration.nix
│   └── asgard/
│       ├── configuration.nix    # System configuration
│       ├── hardware-configuration.nix
│       ├── secrets.nix         # agenix secrets
│       └── services/
│           └── traefik.nix     # Traefik reverse proxy
│
├── modules/                     # Shared system modules
│   ├── hardware.nix            # Boot, kernel, peripherals
│   ├── nvidia.nix              # NVIDIA GPU drivers
│   ├── desktop.nix             # X11, i3, fonts, input
│   ├── audio.nix               # PipeWire audio
│   ├── programs.nix            # System applications
│   ├── zsh.nix                 # Zsh shell configuration
│   ├── alacritty.nix          # Terminal emulator
│   └── maintenance.nix         # Auto-upgrade & garbage collection
│
├── config/                      # Dotfiles (symlinked to ~/.config)
│   ├── i3/
│   ├── polybar/
│   └── rofi/
│
├── etc/
│   └── nix-ld.nix              # Dynamic linker compatibility
│
└── secrets/                     # agenix encrypted secrets
    └── secrets.nix
```

## Features

### Bifrost Features

#### Desktop Environment
- **i3 Window Manager**: Tiling window manager with autotiling
- **Polybar**: Custom status bar
- **Rofi**: Application launcher
- **Alacritty**: GPU-accelerated terminal (Catppuccin Mocha theme, 90% opacity)
- **Dunst**: Notification daemon

#### System
- **Boot**: systemd-boot with EFI
- **Kernel**: Linux 6.18 with nct6687d sensor module
- **Audio**: PipeWire with ALSA/PulseAudio compatibility
- **GPU**: NVIDIA drivers with modesetting
- **Input**: Norwegian keyboard layout, flat mouse acceleration

#### Development
- VS Code with GNOME Keyring integration
- JetBrains Toolbox
- Git, vim, nixd, nixfmt
- Python (uv package manager)
- Claude Code CLI

#### Applications
- Firefox
- Discord, Spotify
- Steam, Faugus Launcher, Bolt Launcher
- Thunar file manager
- CoolerControl hardware monitoring

### Asgard Features

#### Security
- fail2ban intrusion prevention
- SSH hardening (no root login, key-only authentication)
- Sudo without password for wheel group
- Firewall (ports 22, 80, 443)

#### Services
- **Traefik**: Reverse proxy with automatic HTTPS
  - Cloudflare DNS challenge for Let's Encrypt
  - Dashboard with IP allowlist and basic auth
  - Automatic HTTP to HTTPS redirect

#### Maintenance
- Automatic system upgrades (daily at 02:00 with randomization)
- Weekly garbage collection (10-day retention)

## Configuration Management

### Flake Inputs

```nix
nixpkgs          # NixOS 25.11
home-manager     # release-25.11
llm-agents       # Claude Code CLI
deploy-rs        # Deployment tool
agenix           # Secrets management
```

### Adding Packages

**System packages** (bifrost: `hosts/bifrost/configuration.nix`):
```nix
environment.systemPackages = with pkgs; [
  package-name
];
```

**User packages** (bifrost: `hosts/bifrost/home.nix`):
```nix
home.packages = with pkgs; [
  package-name
];
```

### Adding Modules

1. Create `modules/newmodule.nix`:
```nix
{ config, pkgs, ... }:
{
  # Configuration here
}
```

2. Import in host's `configuration.nix`:
```nix
imports = [
  ../../modules/newmodule.nix
];
```

### Managing Dotfiles

Dotfiles in `config/` are automatically symlinked to `~/.config/` using out-of-store symlinks. Edit them directly - no rebuild required for changes to take effect.

## Secrets Management

Asgard uses agenix for encrypted secrets:

```bash
# Edit secrets
agenix -e secret-name.age

# Secrets are defined in secrets/secrets.nix
# Deployed secrets are available at config.age.secrets.name.path
```

## Deployment

### Deploy Asgard from Bifrost

```bash
deploy .#asgard
```

This uses deploy-rs to build and activate the configuration on the remote server via SSH.

### Manual Deployment

On the target host:
```bash
sudo nixos-rebuild switch --flake .#hostname
```

## Maintenance

### Garbage Collection

```bash
# Manual cleanup
sudo nix-collect-garbage -d
# Or alias
nixclean

# Automatic: configured in modules/maintenance.nix
# - Bifrost: Weekly, >10 day old generations
# - Asgard: Weekly, >10 day old generations
```

### System Upgrades

```bash
# Manual upgrade
sudo nixos-rebuild switch --upgrade --flake .#hostname
# Or alias
nru

# Automatic: Asgard upgrades daily at 02:00
```

### List Generations

```bash
sudo nixos-rebuild list-generations
# Or alias
nixgen
```

## Development

### Code Formatting

Always format Nix files before committing:

```bash
nixfmt file.nix
```

### Aliases (Bifrost)

Defined in `modules/zsh.nix`:
- `nrs` - Rebuild and switch
- `nrt` - Rebuild and test
- `nru` - Rebuild with upgrade
- `nixgen` - List generations
- `nixclean` - Garbage collection

## System Information

### Bifrost
- **NixOS**: 25.11
- **Timezone**: Europe/Oslo
- **Locale**: en_US.UTF-8
- **Keyboard**: Norwegian (no)
- **User**: fjs (networkmanager, wheel, libvirtd)

### Asgard
- **NixOS**: 25.05
- **Timezone**: Europe/Falkenstein
- **Locale**: en_US.UTF-8
- **Console**: Norwegian keymap
- **User**: fjs (wheel)
- **Domain**: asgard.isafter.me

## Technical Details

### Home-Manager Integration (Bifrost)

Home-manager runs as a NixOS module:
- `useGlobalPkgs = true` - Use system nixpkgs
- `useUserPackages = true` - Install to user profile
- `backupFileExtension = "backup"` - Backup conflicting files

### Nix Settings

Both hosts:
- Experimental features: `nix-command`, `flakes`
- Auto-optimization enabled
- Unfree packages allowed

### Build Optimization

- Modular architecture for selective rebuilds
- Separated system/user packages (faster home-manager rebuilds)
- Shared modules reduce duplication

## Requirements

- NixOS 25.11 (bifrost) or 25.05+ (asgard)
- Flakes enabled
- For asgard: SSH access with authorized keys

## Notes

- Hardware configurations are host-specific and auto-generated
- NVIDIA drivers require unfree packages
- Dotfiles changes don't require system rebuilds
- Asgard has passwordless sudo for wheel group
- Traefik dashboard requires IP allowlist (127.0.0.1 or configured IP)

## License

Personal configuration - use at your own discretion.
