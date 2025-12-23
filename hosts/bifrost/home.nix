{
  config,
  pkgs,
  llm-agents,
  deploy-rs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
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
    ../../modules/zsh.nix
    ../../modules/alacritty.nix
  ];
  home.username = "fjs";
  home.homeDirectory = "/home/fjs";
  programs.git.enable = true;
  home.stateVersion = "25.11";

  home.packages =
    (with pkgs; [
      lsd
      neofetch
      discord
      spotify
      btop
      faugus-launcher
      bolt-launcher
      jetbrains-toolbox
      vscode
      flameshot
      uv
      nixd
      nixfmt
      nixfmt-tree
      mcp-nixos
      vim
      dig
      zed-editor-fhs
      nil
      obsidian
      ripgrep
    ])
    ++ [
      llm-agents.packages.${pkgs.system}.claude-code
      deploy-rs.packages.${pkgs.system}.deploy-rs
    ];
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
}
