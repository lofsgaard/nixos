{ config, ... }:

{

  services.cloudflared = {
    enable = true;
    tunnels = {
      "5910e3a3-496e-4bd9-873c-cc150da74484" = {
        credentialsFile = "${config.age.secrets.secret_cloudflared.path}";
        default = "http_status:404";
      };
    };
  };

  services.openssh.settings.Macs = [
    # Current defaults:
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    # Added:
    "hmac-sha2-256"
  ];
}
