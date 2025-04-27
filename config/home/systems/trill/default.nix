{ pkgs, ... }:

{
  imports = [
    ../../common.nix
    ../../modules/graphical-environment
    ../../modules/kanshi
  ];

  services.wlr-graphical-environment.enable = true;
  programs.kanshi = {
    enable = true;
    config = ''
      profile {
        output eDP-1 enable scale 1.75
      }
    '';
  };

  home.stateVersion = "24.11";
}
