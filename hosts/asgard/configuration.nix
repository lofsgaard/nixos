{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/maintenance.nix
    ./services/traefik.nix
    ./secrets.nix
    ../../modules/containers.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "fjs" ];
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.vim
  ];

  services.fail2ban = {
    enable = true;
    bantime = "1h";
  };

  networking.hostName = "asgard";

  time.timeZone = "Europe/Falkenstein";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    fjs = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "podman"
      ];
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

  networking.firewall.allowedTCPPorts = [
    22
    443
    80
  ];

  system.stateVersion = "25.05";
}
