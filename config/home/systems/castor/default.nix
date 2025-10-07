{ inputs, lib, pkgs, stablePkgs, unstablePkgs, patchedPkgs, ... }:
{
  imports = [
    ../../common.nix
    ../../cfg/awesome/castor.nix
    ../../cfg/helix
    ../../cfg/daw
    ../../cfg/email
    ./music.nix
  ];

  home.packages = [
    # inputs.phone-camera-upload.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    (pkgs.callPackage ../../my-programs/transcode-opus { })
  ] ++ (with pkgs; [
    inkscape
    deluge
    # Games.
    lutris
    # Disassembly.
    ghidra-bin
    cutter
    # E-book management.
    stablePkgs.calibre # Temporary build failure
    anki-bin
    wineWowPackages.staging
    winetricks
  ]);

  home.stateVersion = "22.05";
}
