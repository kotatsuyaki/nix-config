{ pkgs, ... }: {
  virtualisation.podman = {
    enable = true;
  };
  virtualisation.docker = {
    enable = true;
  };
}
