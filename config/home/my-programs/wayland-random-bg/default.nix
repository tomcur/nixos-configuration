{ lib, pkgs, ... }:
pkgs.writeScriptBin "wayland-random-bg" ''
  FILE=$(${pkgs.coreutils}/bin/shuf -n1 -e ~/Backgrounds/16-9/*)
  ${pkgs.swaybg}/bin/swaybg -m fit -i $FILE
''
