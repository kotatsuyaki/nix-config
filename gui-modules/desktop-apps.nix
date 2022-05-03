{ pkgs, lib, self, system, ... }:
{
  environment.systemPackages = with pkgs; [
    self.packages.${system}.wezterm
    chromium
    kotatogram-desktop
    teams
    zathura
    mpv
    gimp
    feh
    gtkwave
    appimage-run

    firefox

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
