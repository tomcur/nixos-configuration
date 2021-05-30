{ pkgs, lib, buildPythonPackage, feh, gnugrep, xorg }:
let
  pkg = buildPythonPackage rec {
    pname = "paper";
    version = "1.0.0";

    src = ./.;
    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/tomcur/nix-home/tree/master/my-programs/paper";
      description = "Sets wallpapers";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
  runtime = pkgs.buildEnv
    rec {
      name = "paper-env";
      paths = [ feh gnugrep xorg.xrandr ];
    };
in
pkgs.symlinkJoin {
  name = "paper-wrapped";
  paths = [ pkg ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/paper \
      --prefix PATH : "${runtime}/bin"
  '';
}
