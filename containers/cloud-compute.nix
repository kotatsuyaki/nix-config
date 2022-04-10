{ hostname }: { pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    qemu_kvm
  ];

  # This allows building with nixos-container without specifying root fs
  boot.isContainer = true;

  users.motd = "*** You're logged in to ${hostname} ***";

  networking = {
    hostName = hostname;

    networkmanager.enable = false;
    firewall.enable = false;
    nameservers = [ "8.8.8.8" ];

    # Setup bridged network
    bridges.br0 = {
      interfaces = [ "eth0" ];
    };
    interfaces.br0.useDHCP = true;
  };

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      system-features = kvm
    '';
  };
}
