{
  pkgs,
  config,
  lib,
  ...
}: {
  nix-daemon = {
    enable = true;
  };
  yabai = import ./yabai {inherit pkgs config lib;};
}
