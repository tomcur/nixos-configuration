{ ... }: {
  fileSystems =
    let
      nfsSoftDevice = uri: {
        device = uri;
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "noauto"
          "timeo=30"
          "soft"
          "_netdev"
        ];
      };
    in
    {
      "/mnt/music" = nfsSoftDevice "10.0.1.1:/music";
      "/mnt/movies" = nfsSoftDevice "10.0.1.1:/movies";
      "/mnt/series" = nfsSoftDevice "10.0.1.1:/series";
      "/mnt/stream" = nfsSoftDevice "10.0.1.1:/music";
      "/mnt/torrents" = nfsSoftDevice "10.0.1.1:/torrents";
      "/mnt/torrents-bulk" = nfsSoftDevice "10.0.1.1:/torrents-bulk";
      "/mnt/soulseek" = nfsSoftDevice "10.0.1.1:/soulseek";
    };
}
