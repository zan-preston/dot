{
  workMachine
}: {pkgs, ...}: let
  dev-tools = with pkgs; [
#    coursier
#    scala-cli
#    sbt
    go
#    nodejs_18
     nodejs
    cargo
  ];
  core-tools = with pkgs; [
    act
    bat
    claude-code
    colordiff
    coreutils
    curl
    docker
    du-dust
    fd
    ffmpeg
    fm-go
    fx
    fzf
    gh
    # ghostty
    gimp
    git
    glab
    glow
    gnupg
    gnutls
    graphicsmagick
    gum
    home-manager
    htop
    imagemagick
    jira-cli-go
    jq
    jqp
    keychain
    lua51Packages.lua
    lua51Packages.luarocks
    neovim
    nmap
    obsidian
    ollama
    opencode
    pandoc
    podman-tui
    ripgrep
    sshuttle
    starship
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
