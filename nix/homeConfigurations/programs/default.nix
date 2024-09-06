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
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.ff = "only";
      user = {
        name = "shanehull";
        email = "hello@shanehull.com";
        signingkey = "954E6CE09F184BF5";
      };
    };
  };
}
