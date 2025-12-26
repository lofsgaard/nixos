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
    noctalia = "noctalia";
    niri = "niri";
  };
in
{
  imports = [
    ../../modules/zsh.nix
    ../../modules/alacritty.nix
  ];
  home.username = "fjs";
  home.homeDirectory = "/home/fjs";
  home.stateVersion = "25.11";

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Vimix-Cursors";
      size = 24;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Andreas Løfsgaard";
        email = "andreas@lofsgaard.com";
      };
      init.defaultBranch = "main";
    };
  };

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
      zed-editor-fhs
      nil
      obsidian
      ripgrep
      nwg-look
      adwaita-icon-theme
      catppuccin-gtk
      vimix-cursors
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
