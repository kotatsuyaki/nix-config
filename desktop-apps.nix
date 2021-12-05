{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm
    chromium
    tdesktop
    teams
    zathura
    mpv
    gimp
    feh
    gtkwave

    firefox-bin

    sublime4
    sublime-merge
    minecraft
  ];

  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
}
