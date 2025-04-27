{ config, lib, pkgs, ... }:
let
  cfg = config.services.wlr-graphical-environment;
in
{
  options.services.wlr-graphical-environment = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable some wlr-graphical environment tools and services.");
  };
  config = lib.mkIf cfg.enable {
    systemd.user.targets.wlr-graphical-session = {
      Unit = {
        Description = "Wayland-roots graphical environment target.";
        After = [ "default.target" ];
        Wants = [ "default.target" ];
      };
    };
  };
}
