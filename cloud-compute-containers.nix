{ interface }: {
  # Setup bridge on the host
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
  networking.bridges.br0.interfaces = [ interface ];
  networking.interfaces.br0.useDHCP = true;

  containers.host1 = {
    config = (import ./containers/cloud-compute.nix { hostname = "host1"; });
    privateNetwork = true;
    # localAddress is also omitted since the container uses DHCP directly
    hostBridge = "br0";
    # Mount /dev/kvm inside the container so that it qemu works
    bindMounts = {
      "/dev/kvm" = {
        hostPath = "/dev/kvm";
        isReadOnly = false;
      };
    };
  };

  containers.host2 = {
    config = (import ./containers/cloud-compute.nix { hostname = "host2"; });
    privateNetwork = true;
    # localAddress is also omitted since the container uses DHCP directly
    hostBridge = "br0";
    # Mount /dev/kvm inside the container so that it qemu works
    bindMounts = {
      "/dev/kvm" = {
        hostPath = "/dev/kvm";
        isReadOnly = false;
      };
    };
  };
}
