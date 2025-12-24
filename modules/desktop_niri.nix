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
    kdePackages.qt5compat
    libsForQt5.qt5.qtgraphicaleffects
    # Add noctalia shell from unstable
    inputs.noctalia.packages.${pkgs-unstable.stdenv.hostPlatform.system}.default
    pkgs-unstable.quickshell
    kdePackages.qt6ct
    catppuccin-qt5ct
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  imports = [
    inputs.noctalia.nixosModules.default
  ];
  services.noctalia-shell.enable = true;
  qt.platformTheme = "qt6ct";
  nixpkgs.config.qt6ct = {
    enable = true;
    platformTheme = "qt6ct";
    style = {
      package = pkgs.catppuccin-qt5ct;
      name = "Catppuccin-Mocha";
    };

  };
  environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";
}
