{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "docker.io/hello-world:latest";
      autoStart = true;
      ports = [ "127.0.0.1:1234:1234" ];
    };
  };
}
