{ pkgs, ... }:
let
  resholvConf = {
    inputs = (with pkgs; [
      jq
      socat
      coreutils
      gawk
    ]) ++ [
      (pkgs.callPackage ../../../nixos/modules/ristate { })
    ];
    interpreter = "${pkgs.bash}/bin/bash";
    execer = [
      "cannot:${pkgs.socat}/bin/socat"
      "cannot:${pkgs.ristate}/bin/ristate"
      "cannot:${pkgs.sway}/bin/swaymsg"
    ];
  };
in
{
  home.packages = [
    pkgs.eww-wayland
  ];

  xdg.configFile."eww/scripts/get-active-workspaces".source = pkgs.resholve.writeScript "get-active-workspaces"
    resholvConf
    (builtins.readFile ./scripts/river-get-active-workspaces);
  xdg.configFile."eww/scripts/get-window-title".source = pkgs.resholve.writeScript "get-window-title"
    resholvConf
    (builtins.readFile ./scripts/river-get-window-title);
  xdg.configFile."eww/scripts/get-workspaces".source = pkgs.resholve.writeScript "get-workspaces"
    resholvConf
    (builtins.readFile ./scripts/river-get-workspaces);
}
