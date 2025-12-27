{ config, ... }:

{
  imports = [
    ../../../secrets/secret_cloudflared.nix
  ];

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    cloudflared = {
      image = "docker.io/cloudflare/cloudflared:latest";
      autoStart = true;
      cmd = [
        "tunnel"
        "run"
      ];
      environmentFiles = [ config.age.secrets.secret_cloudflared.path ];
      extraOptions = [ "--network=host" ];
    };
  };
}
