{ pkgs, ... }: {
  boot = {
    # Bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
