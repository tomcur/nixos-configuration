{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.evil-org
      epkgs.evil-collection
      epkgs.calfw
      epkgs.calfw-org
      epkgs.notmuch
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
