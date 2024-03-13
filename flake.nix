{
  description = "Home Manager configuration of Zan Preston";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # The last successful build of wezterm on x86_64-darwin:
    # https://hydra.nixos.org/job/nixpkgs/trunk/wezterm.x86_64-darwin#tabs-links
    nixpkgs-wezterm.url = "github:nixos/nixpkgs/517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";
    # nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # outputs = { nixpkgs, home-manager, neovim-nightly-overlay, nixpkgs-wez, ... }:
  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      overlays = [
      #   neovim-nightly-overlay.overlay
        (final: prev: {
          wezterm = inputs.nixpkgs-wezterm.legacyPackages.${system}.wezterm;
        })
      ];
      pkgs = nixpkgs.legacyPackages.${system};

      allowed-unfree-packages = [
        "postman"
        "vault"
        "appcleaner"
      ];
    in {
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
    };
}
