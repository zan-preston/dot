{
  username,
  homeDirectory,
  stateVersion,
  system,
  workMachine,
  home-manager,
}: {
  pkgs,
  lib,
  ...
}: let
  systemMatchesPredicate = system: predicate:
    lib.systems.inspect.predicates."${predicate}" (lib.systems.parse.mkSystemFromString "${system}");
in {
  imports =
    [
      #(import ./dotfiles.nix {inherit username profile;})
      #./fonts.nix
      # (import ./nixpkgs/node { inherit pkgs system; })
      (import ./packages.nix { inherit workMachine; } )
      # (import ./programs.nix {
      #   inherit workMachine;
      #   isDarwin = systemMatchesPredicate system "isDarwin";
      # })
    ]
    ++ ( lib.optionals (systemMatchesPredicate system "isDarwin") [./darwin.nix] )
    ++ ( lib.optionals workMachine [./work.nix] );
    # ++ (
    #   lib.optionals (systemMatchesPredicate system "isLinux")
    #   [
    #     (import ./node.nix {inherit home-manager;})
    #     ./systemd.nix
    #   ]
    # )
    # ++ (
    #   lib.optionals (systemMatchesPredicate system "isDarwin")
    #   [(import ./mac.nix {inherit username;})]
    # );

  home = {inherit username homeDirectory stateVersion;};
}
