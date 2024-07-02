{pkgs, ...}: {
  programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      historyLimit = 10000;
      escapeTime = 10;
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.rose-pine
      ];
      shortcut = "space";
      extraConfig = ''
      set -g @rose_pine_variant 'moon'
      set -g status-position top
      setw -g mode-keys vi
      bind | split-window -h
      bind - split-window -v
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind r source-file ~/.config/tmux/tmux.conf \;  display "Config Reloaded!"
      '';
    };
}
