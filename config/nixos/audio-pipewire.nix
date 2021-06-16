{ inputs, pkgs, ... }: {
  environment.systemPackages = [ pkgs.qjackctl pkgs.pavucontrol ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    config.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 2048;
      };
    };
    config.jack = {
      "jack.properties" = {
        "node.latency" = "512/44100";
      };
    };
    config.pipewire-pulse = {
      "context.modules" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "32/44100";
            "pulse.default.req" = "32/44100";
            "pulse.max.req" = "32/44100";
            "pulse.min.quantum" = "32/44100";
            "pulse.max.quantum" = "32/44100";
            "server.address" = [ "unix:native" ];
          };
        }
      ];
      "stream.properties" = {
        "node.latency" = "32/44100";
        "resample.quality" = 1;
      };
    };
  };
}
