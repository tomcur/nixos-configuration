{ pkgs, ... }:
let
  resholvConf = {
    inputs = with pkgs; [
      jq
      socat
      hyprland
      coreutils
      gawk
      # sway
    ];
    interpreter = "${pkgs.bash}/bin/bash";
    execer = [
      "cannot:${pkgs.socat}/bin/socat"
      "cannot:${pkgs.hyprland}/bin/hyprctl"
      "cannot:${pkgs.sway}/bin/swaymsg"
    ];
  };
in
{
  home.packages = [
    pkgs.eww-wayland
  ];

  xdg.configFile."eww/scripts/get-active-workspace".source = pkgs.resholve.writeScript "get-active-workspace"
    resholvConf
    (builtins.readFile ./scripts/hypr-get-active-workspace);
  xdg.configFile."eww/scripts/get-window-title".source = pkgs.resholve.writeScript "get-window-title"
    resholvConf
    (builtins.readFile ./scripts/hypr-get-window-title);
  xdg.configFile."eww/scripts/get-workspaces".source = pkgs.resholve.writeScript "get-workspaces"
    resholvConf
    (builtins.readFile ./scripts/hypr-get-workspaces);

  # Read the script and wrap the runtime dependencies
}
