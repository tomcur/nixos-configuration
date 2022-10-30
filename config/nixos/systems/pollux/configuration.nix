{ config, pkgs, ... }: {
  imports = [ ../../common.nix ../../audio-pipewire.nix ../../eduroam.nix ];

  nix.settings.max-jobs = 4;
  nix.buildMachines = [{
    hostName = "castor-builder";
    sshKey = "/root/.ssh/castor-remote-builder";
    system = "x86_64-linux";
    maxJobs = 8;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  networking = {
    hostName = "pollux";
    firewall = {
      allowedTCPPorts = [
        22000 # Syncthing listening
      ];
      allowedUDPPorts = [
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  # Better for SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/8e7809f3-1c3e-4c8f-b4c1-0ba974202c76";
    preLVM = true;
    allowDiscards = true;
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  environment.systemPackages = with pkgs; [ ];

  services.xserver = {
    # Enable touchpad support.
    libinput.enable = true;
    videoDrivers = [ "intel" ];
    xrandrHeads = [ "eDP1" "DP1" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };
  services.acpid = {
    enable = true;
    handlers.headphone-hiss = {
      action = ''
        ${pkgs.alsaUtils}/bin/amixer -c0 sset 'Headphone Mic Boost' 10dB
      '';
      event = "jack/headphone HEADPHONE plug";
    };
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.kvmgt = {
    enable = true;
    vgpus."i915-GVTg_V5_4".uuid = [ "61ad383e-37e9-484d-aa30-740a66f2d950" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
