{ pkgs, ... }: {
  systemd.services.mc-server = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "TerraFirmaCraft 1.7.10 server";
    serviceConfig = {
      ExecStart = "/bin/sh -c '. ./.env && ${pkgs.openjdk8_headless}/bin/java -Xmx6G -jar /home/akitaki/Documents/mcserver/forge-1.7.10-10.13.4.1558-1.7.10-universal.jar -Dlog4j.configurationFile=log4j2_server.xml </run/minecraft.control'";
      ExecStop = "/bin/sh -c 'echo stop > /run/minecraft.control'";
      WorkingDirectory = "/home/akitaki/Documents/mcserver";

      User = "akitaki";
      Sockets = [ "mc-server.socket" ];
    };
  };
  systemd.sockets.mc-server = {
    bindsTo = [ "mc-server.service" ];
    socketConfig = {
      ListenFIFO = "/run/minecraft.control";
      FileDescriptorName = "control";
      RemoveOnStop = true;
      SocketMode = "0660";
      SocketUser = "akitaki";
      SocketGroup = "users";
    };
  };
}
