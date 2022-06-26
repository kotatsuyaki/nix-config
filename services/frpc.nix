{ raw-config }: { pkgs, ... }:
let
  config-file = pkgs.writeTextFile {
    name = "frpc.ini";
    text = raw-config;
  };
in
{
  systemd.services.frpc = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Frp tunnel client";
    serviceConfig = {
      ExecStart = "${pkgs.frp}/bin/frpc -c ${config-file}";
    };
  };
}
