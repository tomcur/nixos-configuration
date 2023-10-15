{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "symbols-nerdfonts";
  version = "3.0.2";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/NerdFontsSymbolsOnly.tar.xz";
    hash = "sha256-clfxFE1MvBUKn3NR/3WxW08R/4HZy0qZZi+S4Pt6WvI=";
    stripRoot = false;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/SymbolsNerdFontMono-Regular.ttf $out/share/fonts/truetype/symbols-nerdfont.ttf
  '';

}
