{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };

  opencode-pkg = inputs.opencode.packages.${system}.default;
  qmd-pkg = inputs.qmd.packages.${system}.default;

  mkGithubReleasePkg = import ./make-github-release-package.nix {inherit pkgs;};

  homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    agentSkills = [
      "github"
      "obsidian-remote"
      "qmd"
      "yfinance"
      "zettel"
    ];
    agentSkillsDirs = [
      ".claude/skills"
      ".gemini/skills"
    ];
    agentSkillLinks = lib.listToAttrs (lib.concatMap (dir:
      map (n:
        lib.nameValuePair "${dir}/${n}" {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/agents/skills/${n}";
        })
      agentSkills)
    agentSkillsDirs);
  in {
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
        sessionVariables = {
          XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
          XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
          XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
          XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";

          EDITOR = "nvim -u ${config.home.homeDirectory}/.config/nvim/init.lua";
          KUBE_EDITOR = "nvim -u ${config.home.homeDirectory}/.config/nvim/init.lua";

          SECOND_BRAIN = "${config.home.homeDirectory}/secondbrain";
          K9S_CONFIG_DIR = "${config.home.homeDirectory}/.config/k9s";
          GEMINI_CLI_SYSTEM_SETTINGS_PATH = "${config.home.homeDirectory}/.config/gemini/settings.json";
          ENABLE_COPILOT = "false";
        };
        file = agentSkillLinks;
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
          gh
          qmd-pkg
          gemini-cli
          amp-cli
          opencode-pkg
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

            # jump words with opt+arrow
            bindkey "^[[1;3C" forward-word
            bindkey "^[[1;3D" backward-word

            # jump beginning/end with opt+shift+arrow
            bindkey "^[[1;4D" beginning-of-line
            bindkey "^[[1;4C" end-of-line
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
            "oc" = "opencode";
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
              name = "shanehull";
              email = "hello@shanehull.com";
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
