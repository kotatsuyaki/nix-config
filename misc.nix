{ pkgs, ... }: {
  environment.variables.EDITOR = "nvim";
  system.stateVersion = "21.05";

  # Decrease systemd timeout
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  security.sudo.extraConfig = ''
    Defaults !tty_tickets
  '';
}
