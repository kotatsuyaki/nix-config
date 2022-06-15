{ pkgs, ... }: {
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [ ];
  environment.systemPackages = with pkgs; [ k3s ];
}
