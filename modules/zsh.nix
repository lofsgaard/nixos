{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "eastwood";
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "systemd"
        "aliases"
      ];
    };
    shellAliases = {
      ls = "lsd";
      zed = "zeditor";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#bifrost";
      nrt = "sudo nixos-rebuild test --flake ~/nixos#bifrost";
      nru = "sudo nixos-rebuild switch --upgrade --flake ~/nixos#bifrost";
      nixclean = "sudo nix-collect-garbage -d";
      nixgen = "sudo nixos-rebuild list-generations --flake ~/nixos#bifrost";

      # Deploy-rs aliases
      deploy-asgard = "deploy ~/nixos#asgard";
      deploy-all = "deploy ~/nixos#";
      deploy-check = "nix flake check";

    };
  };
}
