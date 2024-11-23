{
  pkgs,
  config,
  lib,
  ...
}: {
  services = {
    nix-daemon = {
      enable = true;
    };
    # yabai = import ./yabai {inherit pkgs config lib;};
  };
}
