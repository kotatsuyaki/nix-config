{ pkgs, lib, self, system, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm
    chromium
    kotatogram-desktop
    teams
    skypeforlinux
    zathura
    mpv
    gimp
    feh
    gtkwave
    appimage-run

    firefox
    qbittorrent

    sublime4
    sublime-merge
    musescore
    (minecraft.override {
      jre = pkgs.openjdk8;
    })

    rclone

    libreoffice-qt
  ];

  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  environment.sessionVariables.WEZTERM_CONFIG_FILE = "${../configs/wezterm/wezterm.lua}";
}
