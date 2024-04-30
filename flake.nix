{
  description = "Home Manager configuration of Zan Preston";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # The last successful build of wezterm on x86_64-darwin:
    # https://hydra.nixos.org/job/nixpkgs/trunk/wezterm.x86_64-darwin#tabs-links
    #nixpkgs-wezterm.url = "github:nixos/nixpkgs/517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";
    # nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # outputs = { nixpkgs, home-manager, neovim-nightly-overlay, nixpkgs-wez, ... }:
  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";

      configuration = { pkgs, ... }: {
        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh.enable = true;
      };

      pkgs = nixpkgs.legacyPackages.${system};

      extraNodePkgs = import ./nixpkgs/node { inherit pkgs system; };

      overlays = [
      #   neovim-nightly-overlay.overlay
        (final: prev: {
          #wezterm = inputs.nixpkgs-wezterm.legacyPackages.${prev.system}.wezterm;
          dexsearch = extraNodePkgs.dexsearch;
        })
      ];

      allowed-unfree-packages = [
        "postman"
        "vault"
        "appcleaner"
        "obsidian"
      ];
    in {
      
      darwinConfigurations.DQJ36L2FJ1 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          {}
        ];
      };

      # `home-manager switch --flake '.config#zan'`
      homeConfigurations.zan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          { nixpkgs.overlays = overlays; }
          ./nixpkgs/home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {inherit allowed-unfree-packages;};
      };
    packages.aarch64-darwin.dexsearch = extraNodePkgs.dexsearch;
    };
}
