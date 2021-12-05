{ pkgs, ... }: {
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = false;
    networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
