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
            overlays = [
              (final: prev: {
                mole = final.buildGoModule {
                  pname = "mole";
                  version = "latest";
                  src = final.fetchFromGitHub {
                    owner = "tw93";
                    repo = "Mole";
                    rev = "main";
                    hash = "sha256-V55LOHRwbikYpir3oD+uVkw05bWmMfA3mY3DcNDslwY=";
                  };
                  proxyVendor = true;
                  vendorHash = "sha256-8jpELwcEVdo2gV9KbJz5KttluSRN+hYQeo+ZZ4gFkTk=";
                  subPackages = ["cmd/analyze" "cmd/status"];
                  postInstall = ''
                    mkdir -p $out/bin $out/lib
                    cp $src/mole $out/bin/mole
                    chmod +x $out/bin/mole
                    cp $src/bin/clean.sh $out/bin/clean.sh
                    cp $src/bin/optimize.sh $out/bin/optimize.sh
                    cp $src/bin/purge.sh $out/bin/purge.sh
                    chmod +x $out/bin/clean.sh
                    chmod +x $out/bin/optimize.sh
                    chmod +x $out/bin/purge.sh
                    cp -r $src/lib/* $out/lib/
                    sed -i "s|SCRIPT_DIR=.*|SCRIPT_DIR=\"$out\"|" $out/bin/mole
                    ln -sf $out/bin/analyze $out/bin/analyze.sh
                    ln -sf $out/bin/status $out/bin/status.sh
                    ln -sf $out/bin/analyze $out/lib/analyze.sh
                    ln -sf $out/bin/status $out/lib/status.sh
                  '';
                  meta.platforms = nixpkgs.lib.platforms.darwin;
                };
              })
            ];
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
