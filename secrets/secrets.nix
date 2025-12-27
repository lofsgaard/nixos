let
  fjs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ALja6Trt7Gvdl7Dc+5TykXU6nel4tQhCwhxDuGlTg";
  asgard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwcYRLut6VTOsV7swPSXvvwEIh1YqAmSGklcF+ZSjE";
  helheim = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1V9B7I3PFcfBcc5shQ7PYiDXKcrg81n+TYCozVwBZq";
in
{
  "secret_cloudflare.age".publicKeys = [
    fjs
    asgard
    helheim
  ];
  "secret_cloudflared.age".publicKeys = [
    fjs
    asgard
    helheim
  ];
}
