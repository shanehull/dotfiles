{
  pkgs,
  config,
  lib,
  ...
}: {
  enable = true;
  settings = {
    env = {
      TERM = "xterm-256color";
    };
    shell = {
      program = "/bin/zsh";
      args = [
        "-l"
        "-c"
        "${pkgs.tmux}/bin/tmux attach -t main || ${pkgs.tmux}/bin/tmux new-session -t main"
      ];
    };
    window = {
      opacity = 0.80;
      padding = {
        x = 15;
        y = 15;
      };
      dynamic_padding = true;
      decorations = "Buttonless";
    };
    font = {
      normal = {
        family = "Hack Nerd Font";
        style = "Regular";
      };
      bold = {
        family = "Hack Nerd Font";
        style = "Bold";
      };
      italic = {
        family = "Hack Nerd Font";
        style = "Italic";
      };
      bold_italic = {
        family = "Hack Nerd Font";
        style = "Bold Italic";
      };
      size = 13.0;
    };
    colors = {
      # Default colors
      primary = {
        background = "0x282828";
        foreground = "0xd4be98";
      };

      # Normal colors
      normal = {
        black = "0x3c3836";
        red = "0xea6962";
        green = "0xa9b665";
        yellow = "0xd8a657";
        blue = "0x7daea3";
        magenta = "0xd3869b";
        cyan = "0x89b482";
        white = "0xd4be98";
      };

      # Bright colors
      bright = {
        black = "0x565575";
        red = "0xff5458";
        green = "0x62d196";
        yellow = "0xffb378";
        blue = "0x65b2ff";
        magenta = "0x906cff";
        cyan = "0x63f2f1";
        white = "0xa6b3cc";
      };
    };
  };
}
