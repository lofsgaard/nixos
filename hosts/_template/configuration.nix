{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  # REPLACE: Set hostname for new host
  networking.hostName = "HOSTNAME";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "fjs" ];
  };

  boot.loader.grub = {
    enable = true;
    # disko automatically adds devices with EF02 partitions
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
  ];

  time.timeZone = "Europe/Oslo"; # CUSTOMIZE
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    fjs = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # REPLACE: Add your SSH public key
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFSO10/lIejPCuTZq03UlqU/DUzwxj1/NX7hBm74OhRu andreas@lofsgaard.com"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.11";
}
