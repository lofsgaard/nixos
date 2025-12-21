{ config, pkgs, ... }:

{
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

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";  # or your preferred theme
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "systemd"
      ];
    };
    shellAliases = {
      ls = "lsd";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#bifrost";
      nrt = "sudo nixos-rebuild test --flake ~/nixos#bifrost";
      nru = "sudo nixos-rebuild switch --upgrade --flake ~/nixos#bifrost";
      nixclean = "nix-collect-garbage -d";
      nixgen = "sudo nixos-rebuild list-generations --flake ~/nixos#bifrost";
    };
  };

  home.file.".config/i3".source = ./config/i3;
  home.file.".config/polybar".source = ./config/polybar;
  home.file.".config/rofi".source = ./config/rofi;

  home.packages = with pkgs; [
  ];
}
