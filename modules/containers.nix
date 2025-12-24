{ pkgs, ... }:
{

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      autoPrune.enable = true;
    };
  };
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];
  environment.systemPackages = with pkgs; [
    dive
    podman-compose
    podman-tui
  ];
}
