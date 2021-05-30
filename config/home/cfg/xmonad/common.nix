{ lib, pkgs, ... }: {
  home.file.".xmonad/xmonad.hs".text = lib.readFile ./xmonad.hs;
}
