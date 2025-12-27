{
  pkgs,
  ...
}:

{
  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    fuzzel
    mako
    xwayland-satellite
    hyprlock
    hypridle
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.variables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

}
