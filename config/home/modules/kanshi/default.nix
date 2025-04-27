{ config, lib, pkgs, ... }:
let
  cfg = config.programs.kanshi;
in
{
  options.programs.kanshi = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable the Kanshi automatic wlr-based output manager.");
    config = lib.mkOption { description = "The kanshi config file contents."; type = lib.types.string; };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kanshi
    ];

    xdg.configFile."kanshi/config".text = cfg.config;

    systemd.user.services.kanshi = {
      Unit = {
        Description = "Kanshi - automatic wlr-based output management.";
        After = [ "wlr-graphical-session.target" ];
        Wants = [ "wlr-graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "wlr-graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kanshi}/bin/kanshi";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
