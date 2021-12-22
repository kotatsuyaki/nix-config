{ pkgs, ... }: {
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = false;

    # Use DoH
    nameservers = [ "127.0.0.1" "::1" ];
    resolvconf.useLocalResolver = true;
  };

  # DoH service
  services.dnscrypt-proxy2 = {
    enable = true;
    upstreamDefaults = true;
    settings = {
      bootstrap_resolvers = [
        "8.8.8.8:53" # google
        "172.16.0.2:53" # library
      ];
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
    };
  };
}
