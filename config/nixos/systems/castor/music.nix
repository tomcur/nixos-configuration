{ config, pkgs, ... }: {
  services.mopidy = {
    enable = true;
    extensionPackages = [
      pkgs.mopidy-mpd
      pkgs.mopidy-local
      pkgs.mopidy-iris
    ];
    configuration = ''
      [audio]
      output = pulsesink server=127.0.0.1:4713

      [mpd]
      enabled = true
      hostname = ::

      [file]
      enabled = false

      [local]
      enabled = true
      media_dir =
        /home/srv/music/artists
      scan_follow_symlinks = true
    '';
    # ${config.users.home.homeDirectory}/music
  };
}
