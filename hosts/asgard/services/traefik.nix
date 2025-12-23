{
  config,
  ...
}:
{
  services.traefik = {
    enable = true;
    environmentFiles = [ config.age.secrets.secret_cloudflare.path ];
    dataDir = "/var/lib/traefik";

    staticConfigOptions = {
      log = {
        level = "WARN";
      };

      api = {
        dashboard = true;
      };

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
        };
      };

      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "andreas@lofsgaard.com";
            storage = "/var/lib/traefik/acme.json";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = [
                "1.1.1.1:53"
                "8.8.8.8:53"
              ];
              propagation = {
                delayBeforeChecks = "120s";
              };
            };
          };
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        routers = {
          api = {
            rule = "Host(`traefik.isafter.me`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
            service = "api@internal";
            entryPoints = [ "websecure" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
        };
      };
    };
  };
}
