{ config, patchedPkgs, pkgs, ... }: {
  # imports = [ ./mop.nix ];
  # disabledModules = [ "services/audio/mopidy.nix" ];
  # services.mopidy = {
  #   enable = true;
  #   extensionPackages = [
  #     pkgs.mopidy-mpd
  #     pkgs.mopidy-local
  #     pkgs.mopidy-iris
  #   ];
  #   configuration = ''
  #     [audio]
  #     output = pulsesink server=127.0.0.1:4713

  #     [mpd]
  #     enabled = true
  #     hostname = ::

  #     [iris]
  #     enabled = true
  #     country = NL
  #     locale = en_EN
  #     snapcast_enabled = false

  #     [file]
  #     enabled = false

  #     [local]
  #     enabled = true
  #     media_dir =
  #       /home/srv/music/artists
  #     scan_follow_symlinks = true
  #   '';
  # };
}
