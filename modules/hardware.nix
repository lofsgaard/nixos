{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 3;
    
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];
    kernelModules = [ "nct6687" ];
    kernelParams = [ "acpi_enforce_resources=lax" ];
  };

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    
    graphics.enable = true;
    
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
