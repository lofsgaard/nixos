{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      deploy-rs,
      ...
    }:
    {
      nixosConfigurations.bifrost = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit llm-agents; };
        modules = [
          ./hosts/bifrost/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.fjs = import ./hosts/bifrost/home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit llm-agents deploy-rs;
              };
            };
          }
        ];
      };
      nixosConfigurations.asgard = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/asgard/configuration.nix
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
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
