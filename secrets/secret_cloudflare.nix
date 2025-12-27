{
  age = {
    secrets = {
      secret_cloudflare = {
        file = ./secret_cloudflare.age;
        owner = "traefik";
        group = "traefik";
        mode = "0400";
      };
    };
  };
}
