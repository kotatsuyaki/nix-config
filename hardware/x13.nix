{ config, lib, pkgs, modulesPath, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "i8042.probe_defer" ];
  boot.extraModulePackages = [ ];

  services.fwupd.enable = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/244cb5e0-9c0c-41fe-9326-1c09b9191351";
      fsType = "btrfs";
      options = [ "subvol=nixos" "discard" "noatime" "compress=zstd" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/244cb5e0-9c0c-41fe-9326-1c09b9191351";
      fsType = "btrfs";
      options = [ "subvol=home" "discard" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/F4B6-9C23";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/e7d2cf04-47e4-4ee6-b5c7-79fc3a7d363b"; }];

  hardware.bluetooth.enable = true;

  # enable opencl
  hardware.opengl.extraPackages = [
    pkgs.rocm-opencl-icd
    pkgs.rocm-opencl-runtime
  ];
}
