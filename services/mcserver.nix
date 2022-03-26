{ pkgs, ... }: {
  systemd.services.mc-server = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "TerraFirmaCraft 1.7.10 server";
    path = with pkgs; [
      nixFlakes
      git
    ];
    serviceConfig = {
      ExecStart = "/bin/sh -c 'nix develop --command java -Xmx6G -jar /home/akitaki/Documents/mcserver/forge-1.7.10-10.13.4.1558-1.7.10-universal.jar -Dlog4j.configurationFile=log4j2_server.xml'";
      WorkingDirectory = "/home/akitaki/Documents/mcserver";
      User = "akitaki";
    };
  };
}
