{ lib, ... }: {
  imports = [ ./common.nix ];

  home.file.".xmonad/lib/MySystem.hs".text = ''
    module MySystem where
    system = "pollux"
  '';
}
