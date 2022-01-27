{ pkgs, inputs, system, ... }: {
  environment.systemPackages = with pkgs; [
    virt-manager
    podman
    appimage-run
    inputs.unstable.legacyPackages.${system}.quickemu
    spice-gtk
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
    libvirtd.qemu.swtpm.enable = true;
    libvirtd.qemu.ovmf.package = (pkgs.OVMFFull.override {
      secureBoot = true;
      tpmSupport = true;
    });
    podman = {
      enable = true;
      enableNvidia = true;
    };
  };
}
