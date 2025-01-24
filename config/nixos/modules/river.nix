{ config, lib, pkgs, ... }:
let
  cfg = config.programs.my-river-env;

  # dbus-river-environment = pkgs.writeTextFile {
  #   name = "dbus-river-environment";
  #   destination = "/bin/dbus-river-environment";
  #   executable = true;

  #   text = ''
  #     dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP=sway
  #     systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  #     systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  #   '';
  # };
in
{
  options.programs.my-river-env = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable an environment based on River.");
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.vulkan-validation-layers # Necessary in current wlroots to launch with Vulkan renderer
      # dbus-river-environment

      # Required for some applications (such as Neovim) to use the clipboard in Wayland
      pkgs.wl-clipboard

      # River state querying
      (pkgs.callPackage ./ristate {})

      # River layout generators
      pkgs.tarn

      # Screen locker
      pkgs.waylock
    ];

    environment.variables = {
      # WLR_NO_HARDWARE_CURSORS = "1";
    };

    programs.river = {
      enable = true;
    };
    programs.xwayland.enable = true;
    xdg.portal.wlr.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;
    security.pam.services.waylock.text = "auth include login";


    services.greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session =
          let
            river-run = pkgs.writeShellScriptBin "river-run" ''
              # export WLR_RENDERER=vulkan
              export XDG_SESSION_TYPE="wayland"
              export XDG_SESSION_DESKTOP="river"
              export XDG_CURRENT_DESKTOP="river"

              systemd-run --user --scope --collect --quiet --unit="river" \
                systemd-cat --identifier="river" ${config.programs.river.package}/bin/river $@
            '';
            runner = lib.getExe river-run;
          in
          {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --asterisks --time --cmd ${runner}";
          };
      };
    };
  };
}

