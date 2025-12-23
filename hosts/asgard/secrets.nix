{
  age = {
    secrets = {
      secret_cloudflare = {
        file = ../../secrets/secret_cloudflare.age;
        owner = "traefik";
        group = "traefik";
        mode = "0400";
      };
    };
  };
}
