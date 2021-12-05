{ pkgs, ... }: {
  # Font packages
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-serif
    fira-code
    fira-mono
    inconsolata-nerdfont
    iosevka-bin
    corefonts
  ];
}
