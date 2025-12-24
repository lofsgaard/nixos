{
  description = "NixOS configuration for fjs' machines";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      llm-agents,
      deploy-rs,
      agenix,
      ...
    }:
    {
      nixosConfigurations.bifrost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self llm-agents nixpkgs-unstable;
        };
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
                inherit llm-agents deploy-rs agenix;
              };
            };
          }
        ];
      };

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
