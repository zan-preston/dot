{
  description = "Home Manager configuration of Zan Preston";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-wez.url = "github:nixos/nixpkgs/e3652e0735fbec227f342712f180f4f21f0594f2";
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
  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      # overlays = [
      #   neovim-nightly-overlay.overlay
      #   (final: prev: {
      #       wezterm = nixpkgs-wez.legacyPackages.${system}.wezterm;
      #     })
      # ];
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # `home-manager switch --flake '.config#zan'`
      homeConfigurations.zan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ({config, pkgs, ... }:
            # { nixpkgs.overlays = overlays;
            # })
            {})
          ./nixpkgs/home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
