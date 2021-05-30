{ pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../cfg/awesome/pollux.nix
    ../../cfg/daw
    ../../cfg/email
  ];

  # Set some dpi scaling.
  xresources.properties = { "Xft.dpi" = 96; };
}
