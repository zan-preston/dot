{
  description = "Zan's Home-Manager Config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nixpkgs,
    ...
  }: 
  (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [alejandra just];
      };
      defaultApp = {
        type = "app";
        program = "${home-manager.packages.${system}.default}/bin/home-manager";
      };
      # extraNodePkgs = import ./nixpkgs/node { inherit pkgs system}
    }))
      // (let 
      rawHomeManagerConfigurations = {
        "zan@lenny" = {
          system = "x86_64-linux";
          username = "zan";
          homeDirectory = "/home/zan";
          workMachine = false;
          stateVersion = "23.05";
        };
        "APreston@DQJ36L2FJ1" = {
          system = "aarch64-darwin";
          username = "APreston";
          homeDirectory = "/Users/APreston";
          workMachine = true;
          stateVersion = "22.11";
        };
        "zan@despair"= {
          system = "x86_64-darwin";
          username = "zan";
          homeDirectory = "/Users/zan";
          workMachine = false;
          stateVersion = "22.11";
        };
      };

      homeManagerConfiguration = {
        system,
        username,
        homeDirectory,
        workMachine,
        stateVersion,
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          modules = [
            {nixpkgs.config.allowUnfree = true;}
            (import ./home.nix {
              inherit system username homeDirectory stateVersion workMachine home-manager;
            })
          ];
        };
    in {
      # Export home-manager configurations
      inherit rawHomeManagerConfigurations;
      homeConfigurations =
        nixpkgs.lib.attrsets.mapAttrs
        (userAndHost: userAndHostConfig: homeManagerConfiguration userAndHostConfig)
        rawHomeManagerConfigurations;
    })
    // {
      # Re-export flake-utils, home-manager and nixpkgs as usable outputs
      inherit flake-utils home-manager nixpkgs;
    };
}
