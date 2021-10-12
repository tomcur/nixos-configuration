{ stdenv, lib, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "u-he-repro";
  version = "0";

  src = fetchurl {
    url = "https://dl.u-he.com/releases/Repro_112_12092_Linux.tar.xz";
    hash = "sha256-1hCAKlbLjyBywkSYY1aqbUGFlAHBLR8g8xPDIqoUIZk=";
  };

  nativeBuildInputs = [];

  # unpackCmd = ''
  #   mkdir -p root
  #   dpkg-deb -x $curSrc root
  # '';

  # dontBuild = true;
  # dontWrapGApps = true; # we only want $gappsWrapperArgs here

  # buildInputs = with xorg; [
  #   alsaLib cairo freetype gdk-pixbuf glib gtk3 libxcb xcbutil xcbutilwm zlib libXtst libxkbcommon pulseaudio libjack2 libX11 libglvnd libXcursor stdenv.cc.cc.lib
  # ];

  # binPath = lib.makeBinPath [
  #   xdg-utils ffmpeg
  # ];

  # ldLibraryPath = lib.strings.makeLibraryPath buildInputs;

  # installPhase = ''
  #   runHook preInstall

  #   mkdir -p $out/bin
  #   cp -r opt/bitwig-studio $out/libexec
  #   ln -s $out/libexec/bitwig-studio $out/bin/bitwig-studio
  #   cp -r usr/share $out/share
  #   substitute usr/share/applications/com.bitwig.BitwigStudio.desktop \
  #     $out/share/applications/com.bitwig.BitwigStudio.desktop \
  #     --replace Exec=bitwig-studio Exec=$out/bin/bitwig-studio

  #     runHook postInstall
  # '';

  # postFixup = ''
  #   find $out -type f -executable \
  #     -not -name '*.so.*' \
  #     -not -name '*.so' \
  #     -not -name '*.jar' \
  #     -not -path '*/resources/*' | \
  #   while IFS= read -r f ; do
  #     patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
  #   done

  #   # find $out -type f -executable -name 'jspawnhelper' | \
  #   # while IFS= read -r f ; do
  #   #   patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $f
  #   # done

  #   # patchelf fails to set rpath on BitwigStudioEngine, so we use
  #   # the LD_LIBRARY_PATH way

  #   wrapProgram $out/bin/bitwig-studio \
  #     "''${gappsWrapperArgs[@]}" \
  #     --prefix PATH : "${binPath}" \
  #     --suffix LD_LIBRARY_PATH : "${ldLibraryPath}"
  # '';

  meta = with lib; {
    description = "Two classics, recreated";
    homepage = "https://u-he.com/products/repro/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [];
  };
}
