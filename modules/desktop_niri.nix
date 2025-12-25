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

  environment.systemPackages = with pkgs; [
    fuzzel
    swaylock
    mako
    swayidle
    xwayland-satellite
    # Add noctalia shell from unstable
    inputs.noctalia.packages.${pkgs-unstable.stdenv.hostPlatform.system}.default
    pkgs-unstable.quickshell
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  imports = [
    inputs.noctalia.nixosModules.default
  ];
  services.noctalia-shell.enable = true;
}
