{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };

  homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      # ...
    ];
    config = {
      manual.manpages.enable = false;
      fonts.fontconfig.enable = true;
      home = {
        username = "shane.hull";
        homeDirectory = "/Users/shane.hull";
        stateVersion = "25.11";
        packages = with pkgs; [
          # fonts
          fontconfig
          nerd-fonts.hack

          # terminal, shell and editor
          zsh
          wezterm
          tmux
          pam-reattach # for tmux touch id support
          starship
          neovim

          # cli tools
          git
          bat
          tree
          eza
          fzf
          fd
          gawk
          ripgrep
          jq
          yq
          wget
          htop
          fastfetch
          pngpaste
          vhs
          btop
          awscli2
          _1password-cli
          claude-code
          gemini-cli
          github-copilot-cli
          cursor-cli

          # k8s tools
          k9s
          helm-docs
          kustomize
          kubebuilder
          kind

          # mise
          # we do not install any langs using nix
          # mise manages tooling versions via ~/.config/mise/config.toml
          mise
          usage # required for mise autocomplete

          # language tools
          terraform-ls
          tflint
          gopls
          gotools
          golines
          golangci-lint
          templ
          air
          stylua
          prettierd
          eslint_d
          statix
          alejandra
          yamlfmt
          yamllint
          lua-language-server
          lexical
          postgresql_14

          # other
          gnupg
          openssl
          lz4
          aerospace
        ];
      };
      programs = {
        home-manager = {
          enable = true;
        };
        zsh = {
          enable = true;
          initContent = ''
            # starship prompt
            eval "$(starship init zsh)"

            # autocomplete color
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=246'

            # go path
            export PATH=$PATH:$(go env GOPATH)/bin

            # second brain dir
            export SECOND_BRAIN=$HOME/secondbrain

            # editors
            export EDITOR='nvim -u ~/.config/nvim/init.lua'
            export KUBE_EDITOR='nvim -u ~/.config/nvim/init.lua'

            # k9s config dir
            export K9S_CONFIG_DIR=$HOME/.config/k9s

            # jump words with opt+arrow
            bindkey "^[[1;3C" forward-word
            bindkey "^[[1;3D" backward-word

            # jump beginning/end with opt+shift+arrow
            bindkey "^[[1;4D" beginning-of-line
            bindkey "^[[1;4C" end-of-line

            # remotectl autocompletion
            compdef remotectl
            compdef _remotectl remotectl
            source <(remotectl completion zsh)

            # set aws profile to sts
            export AWS_PROFILE=sts

            # use terraform for terragrunt
            export TG_TF_PATH=$(which terraform)

            # use copilot
            export ENABLE_COPILOT=true
          '';
          oh-my-zsh = {
            enable = true;
            plugins = [
              "macos"
              "git"
              "kubectl"
              "mise"
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
            ":q" = "exit";
          };
          autosuggestion = {
            enable = true;
          };
          syntaxHighlighting = {
            enable = true;
          };
          enableCompletion = true;
        };
        tmux = {
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
        };
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
          settings = {
            user = {
              name = "shane.hull";
              email = "shane.hull@remote.com";
            };
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
          signing = {
            signByDefault = true;
            key = "954E6CE09F184BF5";
          };
        };
        mise = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    };
  };
  nixosModule = _: {
    home-manager.users = {
      "shane.hull" = homeModule;
    };
  };
in
  inputs.home-manager.lib.homeManagerConfiguration {
    modules = [
      homeModule
    ];
    pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  }
  // {inherit nixosModule;}
