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

    sublime4
    sublime-merge
    minecraft
  ];
}
