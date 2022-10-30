{ pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../cfg/awesome/pollux.nix
    ../../cfg/email
  ];

  home.packages = with pkgs; [
    anki
  ];

  # Set some dpi scaling.
  xresources.properties = { "Xft.dpi" = 120; };

  home.stateVersion = "22.05";
}
