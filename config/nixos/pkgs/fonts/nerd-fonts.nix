{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "symbols-nerdfonts";
  version = "2021-07-03";

  src = fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/raw/bc4416e176d4ac2092345efd7bcb4abef9d6411e/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf";
    name = "symbols.ttf";
    hash = "sha256-32vlj3cHwOjJvDqiMPyY/o+njPuhytQzIeWSgeyklgA=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/symbols-nerdfont.ttf
  '';

}
