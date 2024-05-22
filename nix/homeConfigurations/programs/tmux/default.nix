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
    set -g status-style fg=black,bg=white
    set -g status-position top

    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
  '';
}
