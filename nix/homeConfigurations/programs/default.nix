{
  pkgs,
  config,
  lib,
  ...
}: {
  home-manager = {
    enable = true;
  };

  zsh = import ./zsh {inherit pkgs config lib;};
  tmux = import ./tmux {inherit pkgs config lib;};

  starship = {
    enable = true;
  };
  bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
      pager = "less -FR";
    };
  };
  eza = {
    enable = true;
  };
  fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  git = {
    enable = true;
    userName = "shanehull";
    userEmail = "hello@shanehull.com";
    signing = {
      signByDefault = true;
      key = "B53433348CA2F9F9";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
    };
  };
}
