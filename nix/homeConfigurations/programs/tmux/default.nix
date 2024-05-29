{
  pkgs,
  config,
  lib,
  ...
}: {
  enable = true;
  historyLimit = 100000;
  keyMode = "vi";
  terminal = "screen-256color";
  extraConfig = ''
    set-option -g prefix C-s

    set -g status-style fg=black,bg=white
    set -g status-position top

    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
    bind-key -T copy-mode-vi 'y' send -X copy-selection
  '';
}
