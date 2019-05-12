{ config, pkgs, ...}:

{
  imports = [
    ../common.nix
  ];

  networking = {
    hostName = "pollux";
  };

  # Better for SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/8e7809f3-1c3e-4c8f-b4c1-0ba974202c76";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  environment.systemPackages = with pkgs; [
  ];

  services.xserver = {
    # Enable touchpad support.
    libinput.enable = true;
  };

  hardware.brightnessctl.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
