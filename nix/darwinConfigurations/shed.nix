{inputs, ...} @ flakeContext: let
  darwinModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.shed.nixosModule
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
      services = {
        nix-daemon = {
          enable = true;
        };
      };
      users = {
        users.shane.home = "/Users/shane";
      };
      system = {
        stateVersion = 4;
        defaults = {
          dock = {
            autohide = true;
            show-recents = false;
          };
        };
      };
      environment = {
        shells = [pkgs.bash pkgs.zsh];
        systemPackages = [pkgs.coreutils];
      };
      homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        casks = ["multipass"];
        brews = [];
      };
      # this doesn't work with tmux
      security.pam.enableSudoTouchIdAuth = true;
      # use pam_reattach in addition to pam_tid so it works  with tmux
      # pam_reattach is installed via ../homeConfigurations/packages/default.nix
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
