{
  pkgs,
  config,
  lib,
  ...
}: {
  enable = true;
  initExtra = ''
    # starship prompt
    eval "$(starship init zsh)"

    # autocomplete color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=246'

    # asdf init
    ASDF_DIR="${pkgs.asdf-vm}"/share/asdf-vm
    . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

    # homebrew path
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # go path
    export PATH=$PATH:$(go env GOPATH)/bin

    # second brain dir
    export SECOND_BRAIN=$HOME/secondbrain

    # editors
    export EDITOR='nvim -u ~/.config/nvim/init.lua'
    export KUBE_EDITOR='nvim -u ~/.config/nvim/init.lua'

    # k9s config dir
    export K9S_CONFIG_DIR=$HOME/.config/k9s
  '';
  oh-my-zsh = {
    enable = true;
    plugins = [
      "macos"
      "git"
      "thefuck"
      "kubectl"
      "asdf"
      "dotenv"
      "terraform"
    ];
  };
  shellAliases = {
    "v" = "nvim";
    "vim" = "nvim";
    "cat" = "bat";
    "ccat" = "bat --plain";
    "brain" = "cd $SECOND_BRAIN";
    "zet" = "shed zet";
    "checkcrt" = "shed checkcrt";
    ":q" = "exit";
  };
  autosuggestion = {
    enable = true;
  };
  syntaxHighlighting = {
    enable = true;
  };
}
