{ lib, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "brightness-control-${version}";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/brightness-control.sh $out/bin/brightness-control
    chmod +x $out/bin/*
    wrapProgram $out/bin/brightness-control --prefix PATH : ${
      lib.makeBinPath [ pkgs.brightnessctl pkgs.glib.bin ]
    }
  '';
}
