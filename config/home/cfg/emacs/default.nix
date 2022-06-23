{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.evil-org
      epkgs.calfw
      epkgs.calfw-org
    ];
    extraConfig = ''
    '';
  };
  home.file = {
    ".emacs.d" = {
      source = ./emacs.d;
      recursive = true;
    };
  };
}
