{ lib, pkgs, ... }:

{
  home.file.".config/redshift.conf".text = ''
    [redshift]
    temp-day=6500
    temp-night=3400
    brightness-day=1.0
    brightness-night=0.75
    location-provider=manual

    [manual]
    lat=52.0
    lon=5.5
  '';

  systemd.user.services.redshift = {
    Unit = {
      Description = "Redshift colour temperature adjuster";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = { ExecStart = "${pkgs.redshift}/bin/redshift"; };
  };
}
