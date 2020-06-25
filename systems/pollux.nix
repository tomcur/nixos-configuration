{ config, pkgs, ... }: {
  imports = [ ../common.nix ../audio-pulse.nix ];

  nix.maxJobs = 4;
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
