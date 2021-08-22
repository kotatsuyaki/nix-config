{ config, pkgs, lib, ... }:

let
  # to add nixos-unstable channel:
  # nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # nix-channel --update
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  my-neovim = import ./neovim.nix { pkgs = unstable; };

  # lists of packages, divided into several categories
  web-gui-apps = with pkgs; [ chromium tdesktop thunderbird birdtray teams ];
  office-gui-apps = with pkgs; [ libreoffice lyx ];
  media-gui-apps = with pkgs; [ unstable.musescore zathura mpv gimp feh ];
  dev-gui-apps = with pkgs; [ alacritty unstable.sublime4 sublime-merge ];

  system-prog-langs = with pkgs; [ python3 nodejs ];
  games = with pkgs; [ minecraft ];

  de-clis = with pkgs; [ wmctrl xdotool play-with-mpv xsel ];
  media-clis = with pkgs; [ mpc_cli mpd mpdris2 ncmpcpp ffmpeg imagemagick ];
  system-clis = with pkgs; [ aria2 bat curl fzf git ripgrep tmux wget zsh ];
  system-tuis = with pkgs; [ htop lazygit ranger ueberzug ];

  archive-utils = with pkgs; [ unrar p7zip unzip ark ];
  virt-utils = with pkgs; [ libvirt virt-manager podman appimage-run ];
  kde-support = with pkgs; [
    kwallet-pam
    plasma-browser-integration
    libnotify
    libappindicator-gtk3
    plasma5Packages.kio-extras
    gnome.adwaita-icon-theme
  ];
in
{
  ### Local config files ###
  # hardware-configuration.nix should be generated during install.
  # hostname.nix must contain ` networking.hostName = "rx570-nixos"; `.
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/hostname.nix
    /etc/nixos/cachix.nix
  ];

  config = lib.mkMerge [{
    ### Packages ###
    environment.systemPackages = builtins.concatLists [
      web-gui-apps
      office-gui-apps
      dev-gui-apps
      games
      system-clis
      system-tuis
      system-prog-langs
      de-clis
      kde-support
      archive-utils
      media-gui-apps
    ] ++ (with pkgs;
      [
        texlive.combined.scheme-full
        syncthing
        direnv
        my-neovim
      ]);

    # Font packages
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-serif
      fira-code
      fira-mono
    ];

    # Allow some nonfree packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "minecraft-launcher"
      "unrar"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cudatoolkit"
      "libtorch"
      "pytorch"
      "teams"
      "sublime-merge"
      "unzip"
    ];

    ### Basics ###
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.useDHCP = false;
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    networking.networkmanager.insertNameservers = [ "8.8.8.8" "8.8.4.4" ];

    # Firmware thing
    hardware.enableRedistributableFirmware = true;

    # Decrease systemd timeout
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=15s
    '';

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

    # Lorri
    services.lorri.enable = true;

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

    ### User ###
    users.users.akitaki = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "input" ];
      shell = pkgs.zsh;
    };

    ### System env ###
    environment.variables.EDITOR = "nvim";
    system.stateVersion = "21.05";
    environment.etc = {
      # Set git commit --verbose as default
      gitconfig = {
        text = ''
          [commit]
          verbose = true
        '';
        mode = "444";
      };
    };

    ### Virtualisation
    virtualisation = {
      libvirtd.enable = true;
      podman = {
        enable = true;
        enableNvidia = true;
      };
    };

    ### Syncthing ###
    services.syncthing = {
      enable = true;
      user = "akitaki";
      dataDir = "/home/akitaki/Sync";
      configDir = "/home/akitaki/.config/syncthing";
    };

    ### Localization ###
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
    (lib.mkIf (config.networking.hostName == "x13-nixos") {
      environment.systemPackages = with pkgs; [
        fprintd
        libinput-gestures
        tlp
      ];

      # Larger tty font
      console.font = "ter-132n";
      console.packages = with pkgs; [
        terminus
      ];

      # TLP
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNER_ON_BAT = "powersave";
          CPU_SCALING_GOVERNER_ON_AC = "performance";
        };
      };

      # Fingerprint
      services.fprintd.enable = true;
    })
    (lib.mkIf (config.networking.hostName == "rtx3070-nixos") {
      environment.systemPackages = with pkgs; [
        nvidia-docker
        nvidia-podman
        cudatoolkit_11_1
        cudnn_cudatoolkit_11_1
        python3Packages.pytorch-bin
        nvtop
        (libtorch-bin.override { cudaSupport = true; })
      ];

      # Nvidia driver
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.opengl.enable = true;
      hardware.opengl.driSupport32Bit = true;
      # ssh server
      services.sshd.enable = true;
      services.openssh.ports = import /etc/nixos/ssh-ports.nix;
      services.openssh.forwardX11 = true;
      programs.ssh.forwardX11 = true;
      programs.ssh.setXAuthLocation = true;
    })];
}

