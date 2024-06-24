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
    gcc11
    gh
    gimp
    git
    glow
    gnupg
    graphicsmagick
    gum
    htop
    imagemagick
    jq
    jqp
    keychain
    neovim
    nmap
    obsidian
    pandoc
    pngpaste
    ripgrep
    tmux
    tree
    watch
    wezterm
    youtube-dl
    zellij
    zsh
  ];
in {
  home.packages =
    core-tools
    ++ dev-tools;
}
