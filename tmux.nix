{pkgs, ...}: {
  programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 10000;
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.rose-pine
      ];
      extraConfig = ''
      set -g @rose_pine_variant 'moon'
      bind | split-window -h
      bind - split-window -v
      bind r source-file "~/.config/tmux/tmux.conf" && echo "Config Reloaded!"
      '';
    };
}
