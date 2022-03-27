{ sessions }: { ... }:
let
  map-session =
    { host
    , pubkey
    , user
    , remote-port
    , local-port
    , monitor-port
    , ...
    }: {
      inherit user;
      name = "${user}-${host}-remote-${toString remote-port}-local-${toString local-port}";
      monitoringPort = monitor-port;
      extraArguments = builtins.concatStringsSep " " [
        "-N"
        "-o ExitOnForwardFailure=yes"
        "-o ServerAliveInterval=30"
        "-o ServerAliveCountMax=3"
        "-R ${toString remote-port}:localhost:${toString local-port}"
        "-i ${pubkey}"
        "${host}"
      ];
    };
in
{
  services.autossh.sessions = map map-session sessions;
}
