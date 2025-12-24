{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = { };

  programs.waybar.enable = true; # top bar
  environment.systemPackages = with pkgs; [
    fuzzel
    swaylock
    mako
    swayidle
    xwayland-satellite
    # Add noctalia shell from unstable
    inputs.noctalia.packages.${pkgs-unstable.stdenv.hostPlatform.system}.default
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
