{ inputs, lib, pkgs, unstablePkgs, patchedPkgs, ... }:
{
  imports = [
    ../../common.nix
    ../../cfg/awesome/castor.nix
    ../../cfg/daw
    ../../cfg/email
    ./music.nix
  ];

  home.packages = [
    inputs.phone-camera-upload.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ] ++ (with pkgs; [
    deluge
    # Games.
    lutris
    # Disassembly.
    ghidra-bin
    radare2-cutter
    # E-book management.
    # calibre
  ]) ++ (with unstablePkgs; [
    # E-book management.
    calibre

    wineWowPackages.staging
    winetricks

    # Repositories are often offline. Install through nix-env as to not
    # break this entire configuration's build.
    # steam
    # steam-run
  ]) ++ (with patchedPkgs;
    [
      # Games.
      # lutris
    ]);
}
