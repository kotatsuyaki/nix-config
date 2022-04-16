{ pkgs, ... }: {
  ### MPD Client ###
  environment.systemPackages = with pkgs; [
    cantata
  ];

  ### MPD ###
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
  services.mpd = {
    enable = true;
    user = "akitaki";
    group = "users";
    extraConfig = ''
      music_directory "/home/akitaki/Music"
      follow_outside_symlinks "yes"
      follow_inside_symlinks "yes"
      audio_output {
          type "pulse"
          name "Pulseaudio"
          server "127.0.0.1"
      }
    '';
  };
}
