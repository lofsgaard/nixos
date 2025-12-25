{
  description = "NixOS configuration for fjs' machines";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      agenix,
      ...
    }:
    {
      nixosConfigurations.asgard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          ./hosts/asgard/configuration.nix
          agenix.nixosModules.default
        ];
      };
      nixosConfigurations.helheim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          ./hosts/helheim/configuration.nix
        ];
      };

      deploy = {
        nodes = {
          asgard = {
            hostname = "asgard.isafter.me";
            profiles.system = {
              sshUser = "fjs";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.asgard;
            };
          };
          helheim = {
            hostname = "10.1.10.10";
            profiles.system = {
              sshUser = "fjs";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.helheim;
            };
          };
        };
      };
      checks = {
        x86_64-linux = deploy-rs.lib.x86_64-linux.deployChecks self.deploy;
      };
    };
}
