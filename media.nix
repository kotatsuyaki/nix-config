{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mpc_cli
    mpd
    mpdris2
    ncmpcpp
    ffmpeg
    imagemagick
  ];
}
