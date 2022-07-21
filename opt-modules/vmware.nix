{ pkgs, ... }: {
  virtualisation.vmware.host.enable = true;
  virtualisation.vmware.host.package = pkgs.vmware-workstation;
}
