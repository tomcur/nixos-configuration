{ config, pkgs, ... }:
let system_name = import ./system_name.nix;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "18.09";

  imports = [ (./systems + "/${system_name}") ];
}
