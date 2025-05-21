{
  description = "Zan's Home-Manager Config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nixpkgs,
    nix-darwin,
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
      rawDarwinConfigurations = {
        "despair" = { pkgs, ... }: {
          system.stateVersion = 5;
          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # add myself as a trusted user
          nix.settings.trusted-users = ["zan"];

          programs.zsh.enable = true;
        };
        "ITS-RS-004" = { pkgs, ... }: {
          system.stateVersion = 5;
          # Auto upgrade nix package and the daemon service.
          # services.nix-daemon.enable = true;
          nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # add myself as a trusted user
          nix.settings.trusted-users = ["amprestn"];

          programs.zsh.enable = true;
        };
      };
      rawHomeManagerConfigurations = {
        "zan@lenny" = {
          system = "x86_64-linux";
          username = "zan";
          homeDirectory = "/home/zan";
          workMachine = false;
          stateVersion = "23.05";
        };
        "zan@despair" = {
          system = "x86_64-darwin";
          username = "zan";
          homeDirectory = "/Users/zan";
          workMachine = false;
          stateVersion = "22.11";
        };
        "amprestn@ITS-RS-004" = {
          system = "aarch64-darwin";
          username = "amprestn";
          homeDirectory = "/Users/amprestn";
          workMachine = false;
          stateVersion = "24.11";
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

      darwinConfigurations.despair = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          rawDarwinConfigurations.despair
          {}
        ];
      };
      darwinConfigurations.ITS-RS-004 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          rawDarwinConfigurations.ITS-RS-004
          {}
        ];
      };
    })
    // {
      # Re-export flake-utils, home-manager and nixpkgs as usable outputs
      inherit flake-utils home-manager nixpkgs;
    };
}
