{ config, pkgs, ... }:

{
  # Video drivers declaration
  services.xserver.videoDrivers = [ "nvidia" ];

  # Graphics and NVIDIA configuration
  hardware = {
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
