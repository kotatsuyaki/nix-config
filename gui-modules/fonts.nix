{ pkgs, ... }: {
  # Font packages
  fonts.fonts = with pkgs; [
    source-han-serif
    source-han-sans

    open-sans

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-extra

    iosevka-bin
    corefonts
  ];
}
