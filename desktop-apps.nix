{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.unstable.legacyPackages.x86_64-linux.wezterm
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
    (minecraft.override {
      jre = pkgs.openjdk8;
    })

    rclone

    libreoffice-qt
  ];

  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
}
