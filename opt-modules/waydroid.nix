{ pkgs, ... }: {
  virtualisation.waydroid.enable = true;
  boot.kernelModules = [ "binder_linux" ];
}
