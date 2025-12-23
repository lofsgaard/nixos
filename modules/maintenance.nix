{
  config,
  self,
  ...
}:

{

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
  system.autoUpgrade = {
    enable = true;
    flake = "${self.outPath}#${config.networking.hostName}";
    flags = [
      "--print-build-logs"
      "--update-input"
      "nixpkgs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
}
