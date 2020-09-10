{ config, pkgs, ... }:

{
  imports = [ ../common.nix ../audio-pulse.nix ];

  networking = {
    hostName = "argo";
    firewall = {
      allowedTCPPorts = [
        22000 # Syncthing listening
      ];
      allowedUDPPorts = [
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  time.timeZone = "Europe/Tallinn";

  # Better for SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/f8a7916b-5bdc-4200-92ae-37df4deb1a93";
    preLVM = true;
    allowDiscards = true;
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  environment.systemPackages = with pkgs; [ ];

  services.xserver = {
    # Enable touchpad support.
    libinput.enable = true;
    videoDrivers = [ "nvidia" "displaylink" ];
  };
  services.autorandr.enable = true;
  services.acpid = {
    enable = true;
    handlers.headphone-hiss = {
      action = ''
        ${pkgs.alsaUtils}/bin/amixer -c0 sset 'Headphone Mic Boost' 10dB
      '';
      event = "jack/headphone HEADPHONE plug";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.optimus_prime = {
    enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
