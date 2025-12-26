{
  pkgs-unstable,
  inputs,
  ...
}:

{

  imports = [
    inputs.noctalia.nixosModules.default
  ];
  environment.systemPackages = with pkgs-unstable; [
    inputs.noctalia.packages.${pkgs-unstable.stdenv.hostPlatform.system}.default
    quickshell
  ];

  services.noctalia-shell.enable = true;
}
