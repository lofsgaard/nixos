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
        middlewares = {
          auth = {
            basicAuth = {
              users = [ "admin:$apr1$bJt81xIX$alH.5MEaMA4mHgFMcz7IU1" ];
            };
          };
          dashboard-ip-allowlist = {
            ipAllowList = {
              sourceRange = [
                "127.0.0.1/32"
                "81.191.193.166/32"
              ];
            };
          };
        };

        routers = {
          api = {
            rule = "Host(`asgard.isafter.me`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
            service = "api@internal";
            entryPoints = [ "websecure" ];
            middlewares = [
              "auth"
            ];
            tls = {
              certResolver = "cloudflare";
            };
          };
        };
      };
    };
  };
}
