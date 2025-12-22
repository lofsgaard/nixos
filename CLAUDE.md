# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based configuration for the system "bifrost". The configuration uses home-manager for user-level management and follows a modular architecture with separate concerns for hardware, desktop, audio, and applications.

## Build Commands

All commands assume working from `~/nixos` directory:

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake ~/nixos#bifrost
# Or use alias:
nrs

# Rebuild and test (no bootloader entry, reverts on reboot)
sudo nixos-rebuild test --flake ~/nixos#bifrost
# Or use alias:
nrt

# Rebuild with upgrade (updates flake inputs)
sudo nixos-rebuild switch --upgrade --flake ~/nixos#bifrost
# Or use alias:
nru

# List generations
sudo nixos-rebuild list-generations --flake ~/nixos#bifrost
# Or use alias:
nixgen

# Clean up old generations
sudo nix-collect-garbage -d
# Or use alias:
nixclean

# Format Nix files
nixfmt <file>.nix
```

## Architecture

### Flake Structure

- `flake.nix`: Defines inputs (nixpkgs, home-manager) and outputs (nixosConfigurations.bifrost)
- Uses NixOS 25.11 and home-manager release-25.11
- Home-manager is integrated as a NixOS module with `useGlobalPkgs = true`

### Main Configuration Files

- `configuration.nix`: Imports all modules, defines networking, users, system packages, and Nix settings
- `home.nix`: User-level configuration for user "fjs", manages dotfiles via out-of-store symlinks
- `hardware-configuration.nix`: Auto-generated hardware settings (do not manually edit unless necessary)

### Module Organization

All modules in `modules/` directory:

- `hardware.nix`: Boot loader, kernel (Linux 6.18 with nct6687d sensor module), Logitech device support
- `nvidia.nix`: NVIDIA GPU configuration with modesetting
- `desktop.nix`: X11, i3 window manager, fonts, keyboard (Norwegian layout), mouse settings
- `audio.nix`: PipeWire audio stack
- `programs.nix`: System programs (Firefox, Steam, virt-manager, etc.) and services (GNOME Keyring, libvirtd)
- `zsh.nix`: Zsh with Oh My Zsh (eastwood theme), plugins, and NixOS-specific aliases
- `alacritty.nix`: Terminal configuration with Catppuccin Mocha theme

### Dotfiles Management

Dotfiles in `config/` are symlinked to `~/.config/` using out-of-store symlinks. This means:
- Changes to `config/i3/`, `config/polybar/`, `config/rofi/` take effect immediately
- No rebuild required for dotfile changes
- The symlinks are managed by home-manager in `home.nix` via `xdg.configFile`

### Package Organization

- **System packages** (`configuration.nix`): Core utilities, sensors, audio tools
- **User packages** (`home.nix`): User applications (Discord, Spotify, VS Code, development tools)
- This separation allows faster home-manager rebuilds without affecting system configuration

## Key Implementation Details

### Hostname Reference

The flake configuration name is `bifrost`, which must match in all rebuild commands.

### User Configuration

- Primary user: `fjs`
- Groups: networkmanager, wheel, libvirtd
- Default shell: Zsh (set system-wide via `users.defaultUserShell`)
- Home directory: `/home/fjs`

### Nix Settings

- Automatic garbage collection: weekly, deletes generations older than 10 days
- Auto-optimization enabled (deduplicates Nix store)
- Experimental features: `nix-command` and `flakes` enabled
- Unfree packages allowed (required for NVIDIA, Steam, Discord, VS Code)

### Module Import Pattern

Both `configuration.nix` and `home.nix` import modules:
- System-level modules imported in `configuration.nix`
- User-level modules (zsh.nix, alacritty.nix) imported in both `configuration.nix` and `home.nix`
- When adding a module, consider whether it's system-level or user-level

### Dynamic Linker Support

`etc/nix-ld.nix` provides dynamic linker libraries for non-NixOS binaries compatibility.

## Common Operations

### Adding a Module

1. Create `modules/newmodule.nix` with standard structure:
```nix
{ config, pkgs, ... }:
{
  # Configuration here
}
```

2. Add to imports in `configuration.nix` or `home.nix`

3. Rebuild with `nrs`

### Adding System Packages

Edit `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Add here
];
```

### Adding User Packages

Edit `home.nix`:
```nix
home.packages = with pkgs; [
  # Add here
];
```

### Modifying Dotfiles

Edit files in `config/` directory directly. Changes are live due to out-of-store symlinks.

### Formatting Code

Always format Nix files with `nixfmt` before committing. The repository uses nixfmt for consistent formatting.
