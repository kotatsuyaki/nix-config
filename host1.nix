{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    qemu_kvm
  ];

  # This allows building with nixos-container without specifying root fs
  boot.isContainer = true;

  networking.firewall.enable = false;
  networking.hostName = "host1";
  networking.bridges.br0 = {
    interfaces = [ "eth0" ];
  };
  networking.interfaces.br0.ipv4.addresses = [{
    address = "192.168.200.11";
    prefixLength = 24;
  }];

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      system-features = kvm
    '';
  };
}
