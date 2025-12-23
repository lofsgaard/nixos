let
  fjs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFSO10/lIejPCuTZq03UlqU/DUzwxj1/NX7hBm74OhRu";
  asgard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfwcYRLut6VTOsV7swPSXvvwEIh1YqAmSGklcF+ZSjE";

in
{
  "secret_cloudflare.age".publicKeys = [
    fjs
    asgard
  ];
}
