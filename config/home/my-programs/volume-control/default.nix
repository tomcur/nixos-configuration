{ lib, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "volume-control-${version}";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/volume-control.sh $out/bin/volume-control
    chmod +x $out/bin/*
    wrapProgram $out/bin/volume-control --prefix PATH : ${
      lib.makeBinPath [ pkgs.alsaUtils.out pkgs.glib.bin ]
    }
  '';
}
