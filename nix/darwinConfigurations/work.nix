{inputs, ...} @ flakeContext: let
  darwinModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.work.nixosModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        nixpkgs = {config = {allowUnfree = true;};};
      }
    ];
    config = {
      documentation = {
        doc = {
          enable = false;
        };
      };
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };
      programs = {
        zsh = {
          enable = true;
        };
      };
      users = {
        users."shane.hull".home = "/Users/shane.hull";
      };
      system = {
        stateVersion = 6;
        defaults = {
          dock = {
            autohide = true;
            show-recents = false;
            wvous-br-corner = 3;
            wvous-bl-corner = 4;
          };
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
          };
          trackpad = {
            TrackpadRightClick = true;
            TrackpadThreeFingerDrag = true;
            TrackpadThreeFingerTapGesture = 0;
            Clicking = false;
          };
          controlcenter = {
            Sound = true;
            Bluetooth = true;
          };
          menuExtraClock = {
            ShowSeconds = true;
          };
          CustomUserPreferences = {
            "~/Library/Preferences/com.apple.screencapture.plist" = {
              target = "clipboard";
            };
          };
        };
      };
      environment = {
        shells = [pkgs.bash pkgs.zsh];
        systemPackages = [pkgs.coreutils];
      };
      homebrew = {
        enable = true;
        casks = [
          "multipass"
          "aerospace"
        ];
        taps = [
          "nikitabobko/tap"
        ];
        brews = [
          # kerl (for asdf erlang installs) requires an overly specific openssl install
          # TODO: eliminate openssl brew
          "openssl"
        ];
      };
      # this doesn't work with tmux
      security.pam.enableSudoTouchIdAuth = true;
      # use pam_reattach in addition to pam_tid so it works  with tmux
      # pam_reattach is installed via ../homeConfigurations/packages/default.nix
      # see: https://github.com/LnL7/nix-darwin/issues/985
      environment.etc."pam.d/sudo_local".text = ''
        # Written by nix-darwin
        auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
        auth       sufficient     pam_tid.so
      '';
    };
  };
in
  inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwinModule
    ];
    system = "aarch64-darwin";
  }
