{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.programs.my-river-env;

  dbus-river-environment = pkgs.writeTextFile {
    name = "dbus-river-environment";
    destination = "/bin/dbus-river-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP=river
      systemctl --user stop pipewire xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  tarn-bar = pkgs.callPackage ./tarn-bar { tarn = pkgs.tarn-new; };
in
{
  options.programs.my-river-env = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable an environment based on River.");
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.vulkan-validation-layers # Necessary in current wlroots to launch with Vulkan renderer
      dbus-river-environment

      # Required for some applications (such as Neovim) to use the clipboard in Wayland
      pkgs.wl-clipboard

      # River state querying
      (pkgs.callPackage ./ristate { })

      # River layout generators
      pkgs.tarn

      # New tarn
      pkgs.tarn-new
   
      # Screen locker
      pkgs.waylock

      # Screen temperature
      pkgs.gammastep
    ];

    environment.variables = {
      # WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.river-classic = {
      enable = true;
    };
    programs.xwayland.enable = true;
    xdg.portal.wlr.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;
    security.pam.services.waylock.text = "auth include login";


    services.greetd = {
      enable = true;
      settings =
        let
          sessions = pkgs.symlinkJoin {
            name = "tuigreet-sessions";
            paths =
              let
                river-classic-session = pkgs.writeShellScript "river-run" ''
                  # export WLR_RENDERER=vulkan
                  export XDG_SESSION_TYPE="wayland"
                  export XDG_SESSION_DESKTOP="river"
                  export XDG_CURRENT_DESKTOP="river"

                  # Without this, one OOM-killed process stops the whole session.
                  systemd-run --user --scope --collect --quiet -p OOMPolicy=continue --unit="river" \
                    systemd-cat --identifier="river" ${config.programs.river-classic.package}/bin/river $@
                '';
                tarn-init = pkgs.writeShellScript "tarn-init" ''
                  dbus-river-environment
                  wayland-random-bg &
                  gammastep -l 52:4 -t 6500:4500 -b 1.0:0.9 &

                  # This target only exists if the home config sets it up.
                  systemctl --user start wlr-graphical-session.target 2>/dev/null || true

                  ${lib.getExe tarn-bar} &

                  # Hand off to tarn. River sends SIGTERM on exit.
                  exec ${lib.getExe pkgs.tarn-new}
                '';
                river-new-session = pkgs.writeShellScript "river-new-session" ''
                  # export WLR_RENDERER=vulkan
                  export XDG_SESSION_TYPE="wayland"
                  export XDG_SESSION_DESKTOP="river"
                  export XDG_CURRENT_DESKTOP="river"

                  # Without this, one OOM-killed process stops the whole session.
                  systemd-run --user --scope --collect --quiet -p OOMPolicy=continue --unit="river-new" \
                    systemd-cat --identifier="river-new" ${pkgs.river}/bin/river -c ${tarn-init}
                '';
              in
              [
                (pkgs.writeTextDir "river-classic.desktop" ''
                  [Desktop Entry]
                  Name=River Classic
                  Comment=Dynamic tiling Wayland compositor
                  Exec=${river-classic-session}
                  Type=Application
                '')
                (pkgs.writeTextDir "river-04.desktop" ''
                  [Desktop Entry]
                  Name=River 0.4 + Tarn
                  Comment=Dynamic tiling Wayland compositor
                  Exec=${river-new-session}
                  Type=Application
                '')
              ];
          };
        in
        {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --asterisks --time --sessions ${sessions} ";
          };
        };
    };
  };
}
