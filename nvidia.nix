{ pkgs, ... }: {
  # Nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    nvtop
    nvidia-podman
  ];
  virtualisation.podman.enableNvidia = true;
}
