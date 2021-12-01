{ pkgs, ... }: {
  time.timeZone = "Asia/Taipei";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_TW.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
        fcitx5-gtk
        fcitx5-configtool
      ];
    };
  };
}
