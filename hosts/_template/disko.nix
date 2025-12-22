{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # BIOS boot partition
              priority = 1;
              label = "boot";
            };
            root = {
              size = "100%";
              label = "root";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
                extraArgs = [ "-L" "nixos" ];
              };
            };
          };
        };
      };
    };
  };
}
