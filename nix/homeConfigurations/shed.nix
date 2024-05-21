{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin"; # Use "x86_64-darwin" if you are on an Intel Mac
  pkgs = inputs.nixpkgs.legacyPackages.${system};

  makeGitHubReleasePackage = import ./make-github-release-package.nix {inherit pkgs;};

  quickval = makeGitHubReleasePackage {
    pname = "quickval";
    fname = "quickval-darwin-arm64";
    version = "latest";
    repo = "quickval";
    owner = "shanehull";
    sha256 = "sha256-Pxtz5kFfZt24PG6Z19N9obm2mCXwB8z/qdptPqmkZ1o=";
  };
  shed = makeGitHubReleasePackage {
    pname = "shed";
    fname = "shed-darwin-arm64";
    version = "v0.0.3";
    repo = "shed";
    owner = "shanehull";
    sha256 = "sha256-McEzuLE6+xKwNb5PtXrLVb0GyH1hRQSr5yPLvm9WKzQ=";
  };

  homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    config = {
      manual.manpages.enable = false;
      fonts.fontconfig.enable = true;
      home = {
        stateVersion = "23.11";
        packages = with pkgs; [
          # asdf manages tooling versions via ./.tool-versions
          # we do not install any langs here
          asdf-vm

          # custom packages defined above
          shed
          quickval

          # all other packages
          fontconfig
          (nerdfonts.override {fonts = ["Hack"];})
          git

          # cli tools
          bat
          tree
          eza
          fzf
          fd
          gawk
          thefuck
          ripgrep
          jq
          yq
          wget
          htop
          neofetch
          pngpaste

          # zsh and plugins
          zsh

          # terminal and editor
          warp-terminal
          alacritty
          tmux
          starship
          neovim

          # k8s tools
          k9s
          helm-docs

          # language tools
          terraform-ls
          tflint
          gopls
          gotools
          golines
          golangci-lint
          air
          stylua
          prettierd
          eslint_d
          statix
          alejandra

          # other
          gnupg
          ollama
        ];
        activation = {
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
        git = {
          enable = true;
          extraConfig = {
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            pull.ff = "only";
          };
        };
        bat = {
          enable = true;
          config = {
            theme = "TwoDark";
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
        zsh = {
          enable = true;
          initExtra = ''
            # starship prompt
            eval "$(starship init zsh)"

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
        };
        alacritty = {
          enable = true;
          settings = {
            env = {
              "TERM" = "xterm-256color";
            };
            shell = {
              program = "/bin/zsh";
              args = [
                "-c"
                "${pkgs.tmux}/bin/tmux"
              ];
            };
            window = {
              opacity = 0.7;
              padding = {
                x = 10;
                y = 25;
              };
              dynamic_padding = true;
              decorations = "Transparent";
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
        };
        tmux = {
          enable = true;
          shell = "${pkgs.zsh}/bin/zsh";
          historyLimit = 100000;
          keyMode = "vi";
          terminal = "screen-256color";
          extraConfig = ''
            set status-utf8 on
            set utf8 on

            set -g status-style fg=black,bg=white
            set -g status-position top
          '';
        };
        starship = {
          enable = true;
        };
      };
    };
  };
  nixosModule = {...}: {
    home-manager.users.shane = homeModule;
  };
in
  inputs.home-manager.lib.homeManagerConfiguration {
    modules = [
      homeModule
    ];
    pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  }
  // {inherit nixosModule;}
