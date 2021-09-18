{ inputs, lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.qjackctl pkgs.pavucontrol ];
  security.rtkit.enable = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_5_14;
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
    config.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 8192;
      };
    };
    config.jack = {
      "jack.properties" = {
        "node.latency" = "512/44100";
      };
    };
    config.pipewire-pulse = {
      # "context.modules" = [
      #   {
      #     name = "libpipewire-module-protocol-pulse";
      #     args = {
      #       "pulse.min.req" = "32/44100";
      #       "pulse.default.req" = "32/44100";
      #       "pulse.max.req" = "32/44100";
      #       "pulse.min.quantum" = "32/44100";
      #       "pulse.max.quantum" = "32/44100";
      #       "server.address" = [ "unix:native" ];
      #     };
      #   }
      # ];
      # "stream.properties" = {
      #   "node.latency" = "32/44100";
      #   "resample.quality" = 1;
      # };
    };
  };
}
