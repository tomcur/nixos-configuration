{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.probe-rs-udev;
in
{
  options.hardware.probe-rs-udev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables probe-rs udev rules and ensures 'plugdev' group exists.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "probe-rs-udev";
        destination = "/etc/udev/rules.d/60-probe-rs.rules";

        # See:
        # https://probe.rs/docs/getting-started/probe-setup/
        text = builtins.readFile ./60-probe-rs-rules;
      })
    ];
    users.groups.plugdev = { };
  };
}
