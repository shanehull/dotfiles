{inputs, ...} @ flakeContext: let
  system = "aarch64-darwin"; # Use "x86_64-darwin" if you are on an Intel Mac
  pkgs = inputs.nixpkgs.legacyPackages.${system};

  makeGhReleasePkg = import ./make-github-release-package.nix {inherit pkgs;};

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
        stateVersion = "23.11";
        packages = import ./packages {inherit pkgs lib makeGhReleasePkg;};
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
      programs = import ./programs {inherit pkgs config lib;};
    };
  };
  nixosModule = {...}: {
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
