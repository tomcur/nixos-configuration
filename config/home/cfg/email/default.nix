{ pkgs, lib, ... }: {
  imports = [ ./accounts.nix ];

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;
  programs.alot.enable = true;
  programs.astroid = {
    enable = true;
    externalEditor =
      "urxvt -e nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' '+set fo+=w' %1";
  };

  systemd.user.services.email-fetch = {
    Unit = { Description = "Fetch email and index."; };
    Service = let
      script = pkgs.writeShellScript "email-fetch" ''
        ${pkgs.isync}/bin/mbsync -a && ${pkgs.notmuch}/bin/notmuch new
      '';
    in { ExecStart = "${script}"; };
  };
  systemd.user.timers.email-fetch = {
    Unit = { Description = "Poll email."; };

    Timer = {
      OnUnitActiveSec = "300s";
      OnBootSec = "10s";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
