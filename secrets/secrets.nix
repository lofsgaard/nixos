let
  fjs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1ALja6Trt7Gvdl7Dc+5TykXU6nel4tQhCwhxDuGlTg";
  asgard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwcYRLut6VTOsV7swPSXvvwEIh1YqAmSGklcF+ZSjE";

in
{
  "secret_cloudflare.age".publicKeys = [
    fjs
    asgard
  ];
}
