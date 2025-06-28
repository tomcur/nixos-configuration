{ config, pkgs, ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/music";
    network.listenAddress = "127.0.0.1";
    network.port = 6600;
    extraConfig = ''
      audio_output {
        type    "pulse"
        name    "pulse audio"
      }
      audio_output {
        type    "fifo"
        name    "my_fifo"
        path    "/tmp/mpd.fifo"
        format  "44100:16:2"
      }
    '';
  };

  #services.mpdris2 = {
  #  enable = true;
  #  mpd = {
  #    host = "127.0.0.1";
  #    port = 6600;
  #    musicDirectory = "${config.home.homeDirectory}/music"; }; notifications = true;
  #  multimediaKeys = false;
  #};

  systemd.user.services.mpdris2 = {
    Unit = {
      After = [ "graphical-session-pre.target" "mpd.service" ];
      PartOf = [ "graphical-session.target" ];
      Description = "MPRIS V2.1 support for mpd ";
    };

    Install = { WantedBy = [ "default.target" ]; };

    Service = let
      mpdConf = pkgs.writeText "mpdris2.conf" ''
        [connection]
        host = localhost
        port = 6600
        music_dir = /home/thomas/music
        [Bling]
        notify = True
        mmkeys = False
      '';
    in {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      ExecStart = "${pkgs.mpdris2}/bin/mpDris2 --config=${mpdConf}";
    };
  };

  home.packages = (with pkgs; [
    # MPD controller.
    ncmpcpp
  ]);

  home.file.".ncmpcpp/config".text = ''
    playlist_separate_albums = yes
    media_library_primary_tag = album_artist
  '';

  home.file.".config/vis/config".text = ''
    visualizer.fps=20
    mpd.fifo.path=/tmp/mpd.fifo
    audio.sources=mpd
    audio.stereo.enabled=true
    colors.override.terminal=true
    colors.scheme=rainbow
  '';

  home.file.".config/vis/colors/rainbow".text = ''
    #1F80F3
    #08ADD8
    #06B3D4
    #01D7AF
    #01DBA9
    #0DF47E
    #26FE53
    #2CFF4B
    #4FF829
    #58F522
    #83DE0B
    #8FD506
    #ADBB01
    #BEAA01
    #D78C07
    #E27C0D
    #F65525
    #F94C2B
    #FE2A4D
    #FE2456
    #F20B81
    #D901AC
    #D501B2
    #B007D6
    #AA09DA
    #7C21F4
    #6D2DF9
    #5541FE
    #3E58FE
    #2A70F9
  '';
}
