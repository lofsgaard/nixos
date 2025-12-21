{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    
    xkb = {
      layout = "no";
      variant = "";
    };

    desktopManager.xterm.enable = true;

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
  
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
    };
  };

  console.keyMap = "no";

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];
}
