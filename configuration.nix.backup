{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./etc/nix-ld.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];
    kernelModules = [ "nct6687" ];
    kernelParams = [ "acpi_enforce_resources=lax" ];
  };
  
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; 

  networking.hostName = "bifrost"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    desktopManager = {
      xterm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3lock
        xautolock
        rofi
        autotiling
        polybar
        dunst
     ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
     };
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fjs = {
    isNormalUser = true;
    description = "fjs";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs = {
    zsh.enable = true;
    thunar.enable = true;
    firefox.enable = true;
    steam.enable = true;
    coolercontrol.enable = true;
    ssh.startAgent = false;
    nix-ld.enable = true;
    vscode.enable = true;
    seahorse.enable = true;
    xss-lock.enable = true;
  };


  # Enable GNOME Keyring for password management
  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  wget
  curl
  linuxKernel.packages.linux_6_18.nct6687d
  lm_sensors
  killall
  jq
  wiremix
  ];


  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

    # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
  };

  # Optimize store
  nix.settings.auto-optimise-store = true;

  # Better boot options
  boot.loader.timeout = 3;


  networking.firewall.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}
