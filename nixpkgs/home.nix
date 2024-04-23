{ allowed-unfree-packages, config, lib, pkgs, ... }:

let 
  extraNodePackages = import ./node/default.nix {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "APreston";
  home.homeDirectory = "/Users/APreston";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  };
  home.stateVersion = "22.05";

  # https://code-notes.jhuizy.com/add-custom-npm-to-home-manager/
  #
  # ```
  # cd node
  # nix-shell -p nodePackages.node2nix --command "node2nix -i ./node-packages.json -o node-packages.nix --nodejs-18"
  # ```
  #


  home.packages = with pkgs; [
    neovim
    tmux
    du-dust
    zsh
    ripgrep
    fd
    coursier
    gum
    git
#    libgit2
    jq
    jqp
    scala-cli
    gh
    wezterm
    dexsearch
    k9s
    kubectl
    kubelogin
    kustomize
    newman
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    bitwarden-cli
    keychain
    gcc11
    bat
    gnutls
    colordiff
    coreutils
    curl
    ffmpeg
    fzf
    gnupg
    glow
    go
    htop
    nmap
    pandoc
    #mpv
    vault
    watch
    youtube-dl
    tree
    imagemagick
    graphicsmagick
    gimp
    appcleaner
    postman
    sketchybar
    sketchybar-app-font
    fm-go
    nodejs_21
    #extraNodePackages.dexsearch
    jira-cli-go
    zellij
  ];
#
#  programs.neovim = {
#    enable = true;
#    extraPackages = [ pkgs.libgit2 ];
#  };
}
