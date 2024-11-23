{
  pkgs,
  config,
  lib,
  ...
}: {
  enable = true;
  enableScriptingAddition = true;
  config = {
    auto_balance = "off";
    focus_follows_mouse = "off";
    layout = "bsp";
    mouse_drop_action = "swap";
    mouse_follows_focus = "off";
    window_animation_duration = "0.0";
    window_gap = 5;
    left_padding = 5;
    right_padding = 5;
    top_padding = 5;
    bottom_padding = 5;
    window_origin_display = "default";
    window_placement = "second_child";
    window_shadow = "float";
  };

  extraConfig = let
    rule = "yabai -m rule --add";
    ignored = app:
      builtins.concatStringsSep "\n" (
        map (e: ''${rule} app="${e}" manage=off sticky=off layer=above'') app
      );
    unmanaged = app: builtins.concatStringsSep "\n" (map (e: ''${rule} app="${e}" manage=off'') app);
  in ''
    ${unmanaged [
      "System Settings"
      "Finder"
      "WezTerm"
      "Slack"
      "1Password"
      "Discord"
      "Signal"
    ]}

    ${rule} label="Arc" app="^Arc$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance|[Bb]itwarden)$" manage=off

    yabai -m rule --apply
  '';
}
