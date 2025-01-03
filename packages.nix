{
  workMachine
}: {pkgs, ...}: let
  dev-tools = with pkgs; [
    coursier
    scala-cli
    sbt
    go
    nodejs_18
    cargo
  ];
  core-tools = with pkgs; [
    act
    bat
    colordiff
    coreutils
    curl
    du-dust
    fd
    ffmpeg
    fm-go
    fzf
    gh
    gimp
    git
    glow
    gnupg
    gnutls
    graphicsmagick
    gum
    home-manager
    htop
    imagemagick
    jq
    jqp
    keychain
    lua51Packages.lua
    lua51Packages.luarocks
    neovim
    nmap
    obsidian
    pandoc
    ripgrep
    tree
    watch
    wezterm
    yt-dlp
    zellij
    zsh
  ];
in {
  home.packages =
    core-tools
    ++ dev-tools;
}
