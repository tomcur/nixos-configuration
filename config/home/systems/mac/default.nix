{ pkgs, stablePkgs, ... }:

{
  imports = [
    ../../cfg/nvim
    ../../cfg/alacritty
  ];

  home.packages = [
    (stablePkgs.callPackage ../../../nixos/pkgs/fonts/iosevka.nix { })
    pkgs.ripgrep
    pkgs.jujutsu
  ];

  # macOS font smoothing emboldens glyphs, which doesn't look that great in the terminal.
  targets.darwin.defaults."org.alacritty".AppleFontSmoothing = 0;

  # Disable mouse wheel scroll acceleration.
  targets.darwin.defaults.NSGlobalDomain."com.apple.scrollwheel.scaling" = -1.0;

  services.jankyborders = {
    enable = true;
    settings = {
      style = "square";
      width = 6.0;
      active_color = "0xff93a1a1";
      inactive_color = "0x00000000";
    };
  };

  home.username = "tomch";
  home.homeDirectory = "/Users/tomch";

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
