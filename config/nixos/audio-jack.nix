{ inputs, pkgs, ... }: {
  imports = [ (toString inputs.musnix) ];
  musnix.enable = true;

  sound.enable = true;

  services.jack = {
    jackd = {
      enable = true;
      #extraOptions = [
      #  "-dalsa"
      #  "--device"
      #  "hw:AMP"
      #];
    };

    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  systemd.services.jack.enable = false;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    tcp.enable = true;
    tcp.anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
  };

  users.extraUsers.thomas.extraGroups = [ "audio" "jackaudio" ];

  environment.systemPackages = [ pkgs.qjackctl pkgs.pavucontrol ];
}
