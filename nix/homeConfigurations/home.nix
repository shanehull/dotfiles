{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };

  qmd-pkg = inputs.qmd.packages.${system}.default;

  mkGithubReleasePkg = import ./make-github-release-package.nix {inherit pkgs;};

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
        stateVersion = "25.11";
        username = "shane";
        homeDirectory = "/Users/shane";
        file = {
          ".gemini/skills" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/agents/skills";
          };
          ".cursor/skills" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/agents/skills";
          };
          ".cursor/mcp.json" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/cursor/mcp.json";
          };
        };
        packages = with pkgs; [
          # fonts
          fontconfig
          nerd-fonts.hack

          # terminal, shell and editor
          zsh
          wezterm
          tmux
          pam-reattach # for tmux touch id support
          pinentry_mac # for gpg singing
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
          qmd-pkg
          claude-code
          gemini-cli
          github-copilot-cli
          amp-cli
          cursor-cli
          slides

          # k8s tools
          k9s
          helm-docs
          kustomize
          kubebuilder

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
          beam27Packages.expert
          ocaml-ng.ocamlPackages_5_4.dune_3
          ocaml-ng.ocamlPackages_5_4.utop
          ocaml-ng.ocamlPackages_5_4.odoc
          ocaml-ng.ocamlPackages_5_4.ocaml-lsp
          ocaml-ng.ocamlPackages_5_4.ocamlformat

          # other
          gnupg
          openssl
          lz4
          aerospace
          ollama
          # electrum
          obsidian

          # custom packages from my public git repos
          (mkGithubReleasePkg
            {
              pname = "shed";
              fname = "shed-darwin-arm64";
              version = "v0.1.0";
              repo = "shed";
              owner = "shanehull";
              sha256 = "sha256-mZa3K4DX0BoNNeFo9nQkhRgRNxmCJfdfA6RBnN9xHzY=";
            })
          (mkGithubReleasePkg
            {
              pname = "quickval";
              fname = "quickval-darwin-arm64";
              version = "v1.3.0";
              repo = "quickval";
              owner = "shanehull";
              sha256 = "sha256-DKzsofCM5YElilMFwvCSHzhjtJPAB/sAIucisbITObo=";
            })
        ];
      };
      services = {
        gpg-agent = {
          enable = true;
          defaultCacheTtl = 600;
          maxCacheTtl = 7200;
          pinentry = {
            package = pkgs.pinentry_mac;
          };
        };
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

            # use copilot with nvim
            export ENABLE_COPILOT=false

            # use gemini settings from git
            export GEMINI_CLI_SYSTEM_SETTINGS_PATH="$HOME/.config/gemini/settings.json"
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

            # Amp CLI compatibility settings
            set -g allow-passthrough all
            set -ga terminal-features ",*:hyperlinks"
            set -s set-clipboard on
            set -s extended-keys on
            bind -n S-Enter send-keys -l "\x1b[13;2u"
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
            gpg = {
              program = "${pkgs.gnupg}/bin/gpg";
            };
          };
          signing = {
            signByDefault = true;
            key = "954E6CE09F184BF5";
          };
        };
        gpg = {
          enable = true;
          settings = {
            use-agent = true;
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
      shane = homeModule;
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
