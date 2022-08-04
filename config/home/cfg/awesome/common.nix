{ lib, pkgs, awesomePkg, awesomePlugins, ... }:
let
  lain = pkgs.luaPackages.toLuaModule (pkgs.stdenv.mkDerivation rec {
    pname = "lain";
    version = awesomePlugins.lain.lastModifiedDate;
    src = awesomePlugins.lain;
    buildInputs = [ pkgs.lua ];
    installPhase = ''
      mkdir -p $out/lib/lua/${pkgs.lua.luaversion}/
      cp -r . $out/lib/lua/${pkgs.lua.luaversion}/lain/
      printf "package.path = '$out/lib/lua/${pkgs.lua.luaversion}/?/init.lua;' .. package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${pkgs.lua.luaversion}/lain.lua
    '';
  });
  freedesktop = pkgs.luaPackages.toLuaModule (pkgs.stdenv.mkDerivation rec {
    pname = "freedesktop";
    version = awesomePlugins.freedesktop.lastModifiedDate;
    src = awesomePlugins.freedesktop;
    buildInputs = [ pkgs.lua ];
    installPhase = ''
      mkdir -p $out/lib/lua/${pkgs.lua.luaversion}/
      cp -r . $out/lib/lua/${pkgs.lua.luaversion}/freedesktop/
      printf "package.path = '$out/lib/lua/${pkgs.lua.luaversion}/?/init.lua;' .. package.path\nreturn require((...) .. '.init')\n" > $out/lib/lua/${pkgs.lua.luaversion}/freedesktop.lua
    '';
  });
in
{
  xsession.enable = true;
  # xsession.windowManager.command = "";
  xsession.windowManager.awesome = {
    enable = true;
    package = awesomePkg;
    luaModules = [ lain freedesktop ];
  };

  home.packages = [
    pkgs.sxhkd
  ];

  xdg.configFile."awesome/rc.lua".source = ./rc.lua;
  xdg.configFile."awesome/theme".source = ./icons;
  xdg.configFile."awesome/sharedtags/init.lua".source = "${awesomePlugins.sharedtags.outPath}/init.lua";
  # xdg.configFile."awesome/themes".source = ./awesome-copycats/themes;
  xdg.configFile."sxhkd/sxhkdrc".text = ''
    ##########################
    # Hotkeys.
    ##########################

    super + w
        firefox

    super + f
        dolphin

    ctrl + shift + 1
        thingshare_screenshot full

    ctrl + shift + 2
        thingshare_screenshot display

    ctrl + shift + 3
        thingshare_screenshot window

    ctrl + shift + 4
        thingshare_screenshot region

    # Reload sxhkd configuration.
    super + Escape
        pkill -USR1 -x sxhkd

    ##########################
    # Media keys.
    ##########################

    XF86MonBrightnessUp
        brightness-control up

    XF86MonBrightnessDown
        brightness-control down

    XF86AudioLowerVolume
        volume-control down

    XF86AudioMute
        volume-control toggle-mute

    XF86AudioRaiseVolume
        volume-control up

    XF86AudioPlay
        playerctl play-pause

    XF86AudioStop
        playerctl stop

    XF86AudioPrev
        playerctl previous

    XF86AudioNext
        playerctl next

    F8
      playerctl prev

    F9
      playerctl play-pause

    F10
      playerctl next

    F11
        volume-control down

    F12
        volume-control up
  '';

  # popup = buildVimPluginFrom2Nix rec {
  #   pname = "popup";
  #   version = flake.sources.nvimPopup.lastModifiedDate;
  #   src = flake.sources.nvimPopup;
  #   meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  # };
}
