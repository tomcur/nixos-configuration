{ config, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/7e1666d3-ebfd-4947-a3cb-6ff22e1de9f2";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/445d3e06-e301-4487-ad85-32aee2167ec9";
      fsType = "ext4";
    };

  fileSystems."/media/bulk" =
    {
      device = "/dev/disk/by-uuid/64eb66d2-8aa9-4ac6-b98b-7d91f78e1fae";
      fsType = "btrfs";
      options = [
        "compress=zstd"
      ];
    };

  fileSystems."/mnt/drive0" = {
    device = "/dev/sr0";
    options = [
      "ro,user,noauto,unhide"
    ];
  };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/E58D-9655";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
