{
  ...
}:
{
  imports = [
    ../../modules/traefik.nix
  ];
  services.traefik = {
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
