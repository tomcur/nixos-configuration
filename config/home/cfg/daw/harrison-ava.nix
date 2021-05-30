{ lib, inputs, stdenv, curl, gnutls, libglvnd, libX11, libXext, autoPatchelfHook }:
stdenv.mkDerivation rec {
  pname = "harrison-ava";
  version = "2021-04-08";

  src = "${inputs.harrisonAva}/vst";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    gnutls
    libglvnd
    libX11
    libXext
  ];

  installPhase = ''
    mkdir -p $out/lib/vst
    cp ./* $out/lib/vst
  '';

  preFixup = ''
    for file in $out/lib/vst/*.so; do
      patchelf --replace-needed libcurl-gnutls.so.4 libcurl.so.4 "$file"
    done
  '';
}
