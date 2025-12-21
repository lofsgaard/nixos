{ config, pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    thunar.enable = true;
    firefox.enable = true;
    steam.enable = true;
    coolercontrol.enable = true;
    ssh.startAgent = false;
    nix-ld.enable = true;
    seahorse.enable = true;
    xss-lock.enable = true;
  };

  # Enable GNOME Keyring for password management
  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}
