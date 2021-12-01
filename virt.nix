{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libvirt
    virt-manager
    podman
    appimage-run
  ];

  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      enableNvidia = true;
    };
    waydroid.enable = true;
  };
}
