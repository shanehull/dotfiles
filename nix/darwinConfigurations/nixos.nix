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
        loginShell = pkgs.zsh;
        systemPackages = [pkgs.coreutils];
      };
      homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        casks = ["warp" "multipass"];
        brews = ["cloudflare-wrangler2"];
      };
      # this doesn't work with tmux (adds pam_tid in /etc/pam.d/sudo file)
      security.pam.enableSudoTouchIdAuth = true;
      # additionally, use pam_reattach, as this works with tmux
      # pam_reattach is installed via: ../homeConfigurations/packages/default.nix
      environment.etc."pam.d/sudo_local".text = ''
        auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so # nix-darwin: environment.etc."pam.d/sudo_local".text
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
