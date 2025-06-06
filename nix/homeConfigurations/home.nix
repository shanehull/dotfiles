{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin";
  pkgs = import inputs.nixpkgs {
    inherit system;
  };

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
        stateVersion = "24.11";
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
          lexical
          ocaml-ng.ocamlPackages_5_3.dune_3
          ocaml-ng.ocamlPackages_5_3.utop
          ocaml-ng.ocamlPackages_5_3.odoc
          ocaml-ng.ocamlPackages_5_3.ocaml-lsp
          ocaml-ng.ocamlPackages_5_3.ocamlformat

          # other
          gnupg
          openssl
          lz4
          ollama
          electrum
          obsidian

          # custom packages from my public git repos
          (mkGithubReleasePkg
            {
              pname = "shed";
              fname = "shed-darwin-arm64";
              version = "v0.0.3";
              repo = "shed";
              owner = "shanehull";
              sha256 = "sha256-McEzuLE6+xKwNb5PtXrLVb0GyH1hRQSr5yPLvm9WKzQ=";
            })
          (mkGithubReleasePkg
            {
              pname = "quickval";
              fname = "quickval-darwin-arm64";
              version = "latest";
              repo = "quickval";
              owner = "shanehull";
              sha256 = "sha256-Pxtz5kFfZt24PG6Z19N9obm2mCXwB8z/qdptPqmkZ1o=";
            })
        ];
        activation = {
          # alias nix applications
          # see: https://github.com/nix-community/home-manager/issues/1341
          aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
            app_folder=$(echo ~/Applications);
            for app in $(find "$newGenPath/home-path/Applications" -type l); do
              run rm -f $app_folder/$(basename $app)
              run /usr/bin/osascript \
                -e "tell app \"Finder\"" \
                -e "make new alias file to POSIX file \"$(readlink $app)\" at POSIX file \"$app_folder\"" \
                -e "set name of result to \"$(basename $app)\"" \
                -e "end tell"
            done
          '';
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

            # jump words with opt+arrow
            bindkey "^[[1;3C" forward-word
            bindkey "^[[1;3D" backward-word

            # jump beginning/end with opt+shift+arrow
            bindkey "^[[1;4D" beginning-of-line
            bindkey "^[[1;4C" end-of-line

            # compile flags for openssl
            export LDFLAGS='-L${pkgs.openssl.out}/lib'
            export CPPFLAGS='-I${pkgs.openssl.dev}/include'

            # postgres extra config options
            export LZ4_CFLAGS='-I${pkgs.lz4.dev}/include'
            export LZ4_LIBS='-L${pkgs.lz4.lib}/lib'
            export POSTGRES_EXTRA_CONFIGURE_OPTIONS='--with-lz4 --with-uuid=e2fs'
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
          userName = "shanehull";
          userEmail = "hello@shanehull.com";
          signing = {
            signByDefault = true;
            key = "954E6CE09F184BF5";
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
