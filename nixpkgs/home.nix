{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "zan";
  home.homeDirectory = "/Users/zan";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

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
    jqp
    scala-cli
    gh
    wezterm
    k9s
    kubectl
    kubelogin
  ];
}
