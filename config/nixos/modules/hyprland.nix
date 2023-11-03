{ config, lib, pkgs, ... }:
let
  cfg = config.programs.my-hyprland-env;

  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP=Hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  dpms-idle = pkgs.writeShellScriptBin "dpms-idle" ''
    #!/usr/bin/env bash
    ${pkgs.swayidle}/bin/swayidle -d -w \
      timeout 240 '${config.programs.hyprland.package}/bin/hyprctl dispatch dpms off' \
      resume '${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on' &
  '';
in
{
  options.programs.my-hyprland-env = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable an environment based on Hyprland.");
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vulkan-validation-layers # Necessary in current wlroots to launch with Vulkan renderer
      dbus-hyprland-environment
      dpms-idle
    ];

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = true;
    };
    programs.xwayland.enable = true;
    xdg.portal.wlr.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;


    services.greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session =
          let
            hypr-run = pkgs.writeShellScriptBin "hypr-run" ''
              export WLR_RENDERER=vulkan
              export XDG_SESSION_TYPE="wayland"
              export XDG_SESSION_DESKTOP="Hyprland"
              export XDG_CURRENT_DESKTOP="Hyprland"

              systemd-run --user --scope --collect --quiet --unit="hyprland" \
                systemd-cat --identifier="hyprland" ${config.programs.hyprland.package}/bin/Hyprland $@

              ${config.programs.hyprland.package}/bin/hyperctl dispatch
            '';
            runner = lib.getExe hypr-run;
            # sway-run = pkgs.writeShellScriptBin "sway-run" ''
            #   export WLR_RENDERER=vulkan
            #   export XDG_SESSION_TYPE="wayland"
            #   export XDG_SESSION_DESKTOP="sway"
            #   export XDG_CURRENT_DESKTOP="sway"

            #   systemd-run --user --scope --collect --quiet --unit="sway" \
            #     systemd-cat --identifier="sway" ${config.programs.sway.package}/bin/sway --unsupported-gpu $@
            # '';
            # runner = lib.getExe sway-run;
          in
          {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --asterisks --time --cmd ${runner}";
          };
      };
    };

    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };
  };
}
