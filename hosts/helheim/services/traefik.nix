{
  ...
}:
{
  imports = [
    ../../../secrets/secret_cloudflare.nix
    ../../../modules/traefik.nix
  ];
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          api = {
            rule = "Host(`helheim.isafter.me`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
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
