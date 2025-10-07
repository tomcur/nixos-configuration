{ config, lib, pkgs, ... }:
let
  cfg = config.programs.my-sway-env;

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in
{
  options.programs.my-sway-env = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable an environment based on Sway.");
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vulkan-validation-layers # Necessary in current wlroots to launch with Vulkan renderer
      dbus-sway-environment
    ];

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    programs.xwayland.enable = true;
    xdg.portal.wlr.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;


    services.greetd = {
      enable = true;
      settings = {
        default_session =
          let
            # hypr-run = pkgs.writeShellScriptBin "hypr-run" ''
            #   export XDG_SESSION_TYPE="wayland"
            #   export XDG_SESSION_DESKTOP="Hyprland"
            #   export XDG_CURRENT_DESKTOP="Hyprland"

            #   systemd-run --user --scope --collect --quiet --unit="hyprland" \
            #     systemd-cat --identifier="hyprland" ${config.programs.hyprland.package}/bin/Hyprland $@

            #   ${config.programs.hyprland.package}/bin/hyperctl dispatch
            # '';
            # runner = lib.getExe hypr-run;
            sway-run = pkgs.writeShellScriptBin "sway-run" ''
              export WLR_RENDERER=vulkan
              export XDG_SESSION_TYPE="wayland"
              export XDG_SESSION_DESKTOP="sway"
              export XDG_CURRENT_DESKTOP="sway"

              systemd-run --user --scope --collect --quiet --unit="sway" \
                systemd-cat --identifier="sway" ${config.programs.sway.package}/bin/sway --unsupported-gpu $@
            '';
            runner = lib.getExe sway-run;
          in
          {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --asterisks --time --cmd ${runner}";
          };
      };
    };
  };
}
