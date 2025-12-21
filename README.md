# NixOS Configuration - Bifrost

A declarative NixOS configuration using flakes, featuring i3 window manager, home-manager, and custom dotfiles management.

## System Overview

- **Hostname**: bifrost
- **Window Manager**: i3
- **Terminal**: Alacritty
- **Shell**: Zsh with Oh My Zsh
- **Application Launcher**: Rofi
- **Status Bar**: Polybar
- **Notifications**: Dunst
- **GPU**: NVIDIA (stable drivers)
- **Kernel**: Latest Linux kernel with nct6687d module for sensor monitoring

## Structure

```
.
├── flake.nix                  # Flake configuration with inputs and outputs
├── configuration.nix          # System-wide NixOS configuration
├── hardware-configuration.nix # Hardware-specific settings
├── home.nix                   # Home-manager user configuration
├── modules/
│   └── zsh.nix               # Zsh configuration module
└── config/                    # Dotfiles (symlinked to ~/.config)
    ├── i3/
    ├── polybar/
    └── rofi/
```

## Features

### System Configuration

- **Boot**: systemd-boot with EFI support
- **Kernel**: Latest Linux kernel with custom sensor module (nct6687d)
- **Hardware**: Logitech wireless support, NVIDIA GPU with modesetting
- **Input**: Flat mouse acceleration profile, Norwegian keyboard layout
- **Audio**: PipeWire with ALSA and PulseAudio compatibility

### Desktop Environment

- **i3 Window Manager**: Tiling window manager with autotiling
- **Polybar**: Custom status bar
- **Rofi**: Application launcher and dmenu replacement
- **Dunst**: Notification daemon
- **Alacritty**: GPU-accelerated terminal with 0.9 opacity

### Development Tools

- Firefox browser
- VS Code with GNOME Keyring integration
- Git version control
- Various CLI utilities (lsd, neofetch, btop, wget, jq)

### Applications

- Steam (gaming platform)
- Discord
- Spotify
- Faugus Launcher
- Bolt Launcher
- Thunar file manager
- CoolerControl (hardware monitoring)

## Quick Start

### Initial Installation

1. Clone this repository:

```bash
git clone https://github.com/lofsgaard/nixos.git ~/nixos
cd ~/nixos
```

2. Update hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

3. Build and switch to the new configuration:

```bash
sudo nixos-rebuild switch --flake ~/nixos#bifrost
```

### Regular Usage

Build and activate (with aliases from zsh module):

```bash
nrs  # Rebuild and switch
nrt  # Rebuild and test (no bootloader entry)
nru  # Rebuild with upgrade
```

Clean up old generations:

```bash
nixclean
```

List generations:

```bash
nixgen
```

## Configuration Management

### Home-Manager

User-specific configuration is managed through home-manager in `home.nix`. Dotfiles in the `config/` directory are automatically symlinked to `~/.config/` using out-of-store symlinks, allowing for live editing without rebuilds.

### Adding New Packages

**System-wide** (in `configuration.nix`):

```nix
environment.systemPackages = with pkgs; [
  # Add packages here
];
```

**User-specific** (in `home.nix`):

```nix
home.packages = with pkgs; [
  # Add packages here
];
```

### Adding New Modules

1. Create a new module in `modules/`:

```nix
# modules/example.nix
{ config, pkgs, lib, ...}:
{
  # Module configuration
}
```

2. Import in `home.nix`:

```nix
imports = [
  ./modules/example.nix
];
```

## Customization

### Dotfiles

Edit configuration files directly in `config/` directory:

- **i3**: `config/i3/config`
- **Polybar**: `config/polybar/config.ini`
- **Rofi**: `config/rofi/config.rasi`

Changes take effect immediately (no rebuild required).

### Zsh Configuration

Oh My Zsh is configured with:

- Theme: robbyrussell
- Plugins: git, sudo, docker, kubectl, systemd
- Custom aliases for NixOS management

### Graphics

NVIDIA drivers are configured with:

- Modesetting enabled
- Stable driver package
- Power management disabled
- NVIDIA Settings enabled

## NixOS Version

- **NixOS**: 25.11
- **Home-Manager**: release-25.11
- **Flakes**: Enabled

## Notes

- Unfree packages are allowed (required for NVIDIA drivers, Steam, Discord, etc.)
- Experimental features `nix-command` and `flakes` are enabled
- Default user shell is set to Zsh system-wide
- GNOME Keyring is enabled for credential management (SSH agent disabled)
