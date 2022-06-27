{ pkgs, ... }:
let
  vmware = pkgs.vmware-workstation.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      echo "Removing fonts.conf"
      rm $out/lib/vmware/libconf/etc/fonts/fonts.conf
    '';
  });
in
{
  virtualisation.vmware.host.enable = true;
  virtualisation.vmware.host.package = vmware;
}
