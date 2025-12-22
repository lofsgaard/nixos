{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "fjs" ];
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.vim
  ];

  networking.hostName = "asgard";

  time.timeZone = "Europe/Falkenstein";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    fjs = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
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

  system.stateVersion = "25.05";
}
