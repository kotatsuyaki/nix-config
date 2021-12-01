{ pkgs, ... }: {
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_xanmod;

    # Bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
