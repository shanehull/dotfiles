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
        "${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux"
      ];
    };
    window = {
      opacity = 0.80;
      padding = {
        x = 15;
        y = 25;
      };
      dynamic_padding = true;
      decorations = "transparent";
    };
    scrolling = {
      history = 8000;
      multiplier = 5;
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
        background = "#282828";
        foreground = "#D4BE98";
      };

      # Normal colors
      normal = {
        black = "#3C3836";
        red = "#EA6962";
        green = "#A9B665";
        yellow = "#D8A657";
        blue = "#7DAEA3";
        magenta = "#D3869B";
        cyan = "#89B482";
        white = "#D4BE98";
      };

      # Bright colors
      bright = {
        black = "#565575";
        red = "#FF5458";
        green = "#62D196";
        yellow = "#FFB378";
        blue = "#65B2FF";
        magenta = "#906CFF";
        cyan = "#63f2f1";
        white = "#A6b3CC";
      };
    };
  };
}
