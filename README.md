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
├── configuration.nix          # Main system configuration with imports
├── hardware-configuration.nix # Hardware-specific settings
├── home.nix                   # Home-manager user configuration
├── etc/
│   └── nix-ld.nix            # Dynamic linker libraries for compatibility
├── modules/                   # Modular system configuration
│   ├── hardware.nix          # Boot loader, kernel, Logitech devices
│   ├── nvidia.nix            # NVIDIA GPU configuration
│   ├── desktop.nix           # X11, i3, fonts, input devices
│   ├── audio.nix             # PipeWire audio configuration
│   ├── programs.nix          # System programs and services
│   ├── zsh.nix               # Zsh and Oh My Zsh configuration
│   └── alacritty.nix         # Alacritty terminal configuration
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
- **Alacritty**: GPU-accelerated terminal with 0.9 opacity and Catppuccin Mocha theme
- **Zsh Plugins**: Oh My Zsh with autosuggestions and syntax highlighting

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

### Modular Architecture

The configuration is organized into focused modules for better maintainability:

- **hardware.nix** - Boot configuration, kernel settings, Logitech devices
- **nvidia.nix** - NVIDIA GPU drivers and settings (can be easily disabled)
- **desktop.nix** - X11, i3 window manager, fonts, keyboard/mouse configuration
- **audio.nix** - PipeWire audio stack
- **programs.nix** - System programs (Firefox, Steam, VS Code, etc.) and GNOME Keyring
- **zsh.nix** - Zsh shell with Oh My Zsh, plugins, and custom aliases
- **alacritty.nix** - Terminal emulator with Catppuccin Mocha theme

### Home-Manager

User-specific configuration is managed through home-manager in `home.nix`. Dotfiles in the `config/` directory are automatically symlinked to `~/.config/` using out-of-store symlinks, allowing for live editing without rebuilds.

User packages are separated from system packages for faster rebuilds and better organization.

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

2. Import in `configuration.nix`:

```nix
imports = [
  ./modules/example.nix
];
```

## Optimization Features

- **Automatic Garbage Collection**: Weekly cleanup of generations older than 30 days
- **Store Optimization**: Automatic deduplication of identical files in Nix store
- **Modular Design**: Easy to enable/disable features by commenting out module imports
- **Separated Concerns**: System vs user packages for faster rebuilds

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
- Built-in plugins: git, sudo, docker, kubectl, systemd, aliases
- External plugins: zsh-autosuggestions, zsh-syntax-highlighting
- Custom aliases for NixOS management

### Alacritty Terminal

Configured with:

- Catppuccin Mocha color theme
- 90% window opacity
- 14pt font size
- GPU acceleration

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
