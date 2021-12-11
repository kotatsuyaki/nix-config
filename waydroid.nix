{ pkgs, ... }: {
  virtualisation.waydroid.enable = true;
  boot.kernelModules = [ "binder_linux" ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
}
