{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ./picom.nix {})
  ];
}
