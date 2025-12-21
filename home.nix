{ config, pkgs, ... }:

let
dotfiles = "${config.home.homeDirectory}/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Standard .config/directory
  configs = {
    i3 = "i3";
    polybar = "polybar";
    rofi = "rofi";
  };
in
{ 
  imports = [
    ./modules/zsh.nix
  ];
  home.username = "fjs";
  home.homeDirectory = "/home/fjs";
  programs.git.enable = true;
  home.stateVersion = "25.11";

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.size = 14;
    };
  };

  # Iterate over xdg configs and map them accordingly
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.packages = with pkgs; [
  ];
}
