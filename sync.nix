{ pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "akitaki";
    dataDir = "/home/akitaki/Sync";
    configDir = "/home/akitaki/.config/syncthing";
  };
}
