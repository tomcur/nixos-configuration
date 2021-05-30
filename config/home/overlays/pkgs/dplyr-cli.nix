{ stdenv, lib, fetchurl, makeWrapper, rWrapper, rPackages }:
let
  R-with-packages =
    rWrapper.override { packages = with rPackages; [ docopt dplyr readr knitr ]; };
in stdenv.mkDerivation rec {
  pname = "dplyr-cli";
  version = "bba51b8bc12c43df72a1341acbe1f540f1c390c1";

  buildInputs = [ makeWrapper ];

  src = fetchurl {
    url =
      "https://github.com/coolbutuseless/dplyr-cli/archive/${version}.tar.gz";
    sha256 = "1x4l8ybjnx4rybvvd6v0y6chj4ll4b3121xlnccz9j5s6wrl6dpp";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp dplyr $out/bin/dplyr
    wrapProgram $out/bin/dplyr --prefix PATH : ${
      lib.makeBinPath [ R-with-packages ]
    }
  '';

  meta = with stdenv.lib; {
    description = "Manipulate CSV files on the command line using dplyr";
    homepage = "https://github.com/coolbutuseless/dplyr-cli";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
