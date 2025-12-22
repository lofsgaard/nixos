{ pkgs, config, ... }:

{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          http.tls = {
            certResolver = "cloudflare";
            domains = [
              {
                main = "${hl.domain}";
                sans = [ "*.${hl.domain}" ];
              }
            ];
          };
        };
      };
      certificatesResolvers.letsencrypt.acme = {
        email = "dev@lofsgaard.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      http.routers = { };
      http.services = { };
    };
  };
  services.traefik.staticConfigFile = ./static_config.toml;
  systemd.services.traefik.environment = {
    CF_API_EMAIL_FILE = "/path/to/file";
    CF_DNS_API_TOKEN_FILE = "/path/to/file";
  };
}
