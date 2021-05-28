{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hostname.nix
  ];

  config = lib.mkMerge [{
    ### Packages ###
    environment.systemPackages = with pkgs; [
      # gui apps
      alacritty chromium emacsGcc qutebrowser tdesktop zathura
      # cli devtools
      curl fzf git gnumake htop lazygit p7zip ranger ripgrep vim wget xsel zsh
      # languages
      nodejs python310 nodePackages.typescript
      # gui tools
      wmctrl xdotool
      # multimedia
      elisa mpc_cli mpd mpdris2 mpv ncmpcpp
    ];

    # Font packages
    fonts.fonts = with pkgs; [
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-mono
    ];

    ### Basics ###
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.useDHCP = false;
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # Firmware thing
    hardware.enableRedistributableFirmware = true;

    ### X settings ###
    services.xserver.enable = true;
    services.xserver.xkbOptions = "altwin:swap_alt_win";
    # KDE Plasma
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    # Touchpad
    services.xserver.libinput.enable = true;
    # Printers
    services.printing.enable = true;
    # Audio
    hardware.pulseaudio.enable = true;
    sound.enable = true;

    # MPD
    services.mpd.enable = true;
    hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
    services.mpd.extraConfig = ''
    follow_outside_symlinks "yes"
    follow_inside_symlinks "yes"
    audio_output {
      type "pulse"
      name "Pulseaudio"
      server "127.0.0.1"
    }
  '';

    users.users.akitaki = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "input" ];
      shell = pkgs.zsh;
    };

    # default editor to vim
    # TODO: decide if switching to Emacs is viable
    environment.variables.EDITOR = "vim";

    system.stateVersion = "21.05";

    ### Emacs with native-comp ###
    services.emacs.package = pkgs.emacsUnstable;

    nixpkgs.overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];

    # Localization, timezone, and IME
    time.timeZone = "Asia/Taipei";
    i18n = {
      consoleFont = "latarcyrheb-sun32";
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
  } (lib.mkIf (config.networking.hostName == "x13-nixos") {
    environment.systemPackages = with pkgs; [
      fprintd libinput-gestures tlp
    ];

    # TLP
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNER_ON_BAT = "powersave";
        CPU_SCALING_GOVERNER_ON_AC = "performance";
      };
    };

    services.fprintd.enable = true;
  })];
}
  
