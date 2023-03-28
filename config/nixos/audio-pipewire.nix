{ inputs, lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.qjackctl pkgs.pavucontrol ];
  security.rtkit.enable = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;
  boot.kernelParams = [ "threadirqs" ];
  boot.kernel.sysctl = { "vm.swappiness" = 10; };
  # boot.kernelPatches = [{
  #   name = "preempt-config";
  #   patch = null;
  #   extraConfig = ''
  #     PREEMPT y
  #     PREEMPT_VOLUNTARY n
  #   '';
  # }];
  powerManagement.cpuFreqGovernor = lib.mkForce "performance";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.etc = {
    "pipewire/pipewire.conf.d/21-clock.conf".text = ''
      context.properties = {
        default.clock.max-quantum = 8192
        default.clock.min-quantum = 512
        default.clock.quantum = 2048
        default.clock.rate = 44100
      }
    '';
    "pipewire/jack.conf.d/21-jack.conf".text = ''
      jack.properties = {
        node.latency = 512/44100
      }
    '';
    "pipewire/pipewire-pulse.conf.d/21-pulse.conf".text = ''
      context.properties = {
        context.properties = {
          log.level = 2
        }
        context.modules = [
          {
            name = libpipewire-module-rtkit
            args = {
              nice.level = -15
              rt.prio = 88
              rt.time.soft = 200000
              rt.time.hard = 200000
            }
            flags = [ ifexists nofail ]
          }
          { name = libpipewire-module-protocol-native }
          { name = libpipewire-module-client-node }
          { name = libpipewire-module-adapter }
          { name = libpipewire-module-metadata }
          {
            name = libpipewire-module-protocol-pulse
            args = {
              pulse.min.req = 32/44100
              pulse.default.req = 32/44100
              pulse.max.req = 32/44100
              pulse.min.quantum = 32/44100
              pulse.max.quantum = 32/44100
              server.address = [ unix:native tcp:4713 ]
            }
          }
        ]
        stream.properties = {
          node.latency = 32/44100
          resample.quality = 1
        }
      }
    '';
  };
}
