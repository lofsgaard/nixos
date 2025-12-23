{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    hello-world = {
      image = "docker.io/traefik/whoami:latest";
      autoStart = true;
      ports = [ "42069:80" ];
    };
  };
  services.traefik.dynamicConfigOptions = {
    http.routers.whoami = {
      rule = "Host(`whoami.isafter.me`)";
      entryPoints = [ "websecure" ];
      service = "whoami";
      tls.certResolver = "cloudflare";
    };

    http.services.whoami.loadBalancer.servers = [
      { url = "http://127.0.0.1:42069"; }
    ];
  };
}
