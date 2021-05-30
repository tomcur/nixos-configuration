{ pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../cfg/awesome/pollux.nix
    ../../cfg/email
  ];

  # Set some dpi scaling.
  xresources.properties = { "Xft.dpi" = 120; };
}
