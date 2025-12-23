{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../etc/nix-ld.nix
    ../../modules/hardware.nix
    ../../modules/nvidia.nix
    ../../modules/desktop.nix
    ../../modules/audio.nix
    ../../modules/programs.nix
    ../../modules/zsh.nix
    ../../modules/maintenance.nix
    ../../modules/containers.nix
  ];

  networking = {
    hostName = "bifrost";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.localBinInPath = true;

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.fjs = {
    isNormalUser = true;
    description = "fjs";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    linuxKernel.packages.linux_6_18.nct6687d
    lm_sensors
    killall
    jq
    wiremix
    pulseaudio
    pavucontrol
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.stateVersion = "25.11";
}
