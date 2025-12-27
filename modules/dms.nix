{
  inputs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    inputs.dms.nixosModules.dankMaterialShell
  ];

  programs.dankMaterialShell = {
    enable = true;
  };

  environment.systemPackages = with pkgs-unstable; [
    quickshell
  ];
}
