{ pkgs, ... }: {
  virtualisation.lxd.enable = true;
  users.users.akitaki.extraGroups = [ "lxd" ];
}
