# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/eca2b387-3d42-470b-a1d9-55d1461b8809";
      fsType = "btrfs";
      options = [ "subvol=nixos" "discard" "noatime" "compress=zstd" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/eca2b387-3d42-470b-a1d9-55d1461b8809";
      fsType = "btrfs";
      options = [ "subvol=home" "discard" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5FD4-00DA";
      fsType = "vfat";
    };

  swapDevices = [ ];

  boot.tmpOnTmpfs = true;

  # enable opencl
  hardware.opengl.extraPackages = [ pkgs.mesa.opencl ];
}
