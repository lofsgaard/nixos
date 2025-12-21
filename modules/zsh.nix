{ config, pkgs, ...}:

{
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
}