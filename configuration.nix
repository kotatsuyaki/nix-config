{ config, lib, ... }:

let
  # to add nixos-unstable channel:
  # nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # nix-channel --update
  pkgs = import <nixos> { config.allowUnfree = true; };
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
  my-neovim = import ./neovim.nix { pkgs = unstable; stable = pkgs; };
  wez-neovim = pkgs.makeDesktopItem {
    name = "wez-neovim";
    desktopName = "Neovim in Wezterm";
    exec = "wezterm start -- nvim %F";
    terminal = "false";
  };

  # lists of packages, divided into several categories
  web-gui-apps = with pkgs; [ chromium tdesktop thunderbird birdtray teams ];
  office-gui-apps = with pkgs; [ libreoffice lyx ];
  media-gui-apps = with pkgs; [ unstable.musescore zathura mpv gimp feh ];
  dev-gui-apps = with pkgs; [ wezterm wez-neovim unstable.sublime4 sublime-merge ];
  games = with pkgs; [ minecraft ];
  gui-pkgs = builtins.concatLists [ web-gui-apps office-gui-apps media-gui-apps dev-gui-apps games ];

  de-clis = with pkgs; [ wmctrl xdotool play-with-mpv xsel ];
  media-clis = with pkgs; [ mpc_cli mpd mpdris2 ncmpcpp ffmpeg imagemagick ];
  system-clis = with pkgs; [ aria2 bat curl fzf git ripgrep tmux wget zsh tealdeer ];
  system-tuis = with pkgs; [ htop lazygit ranger ueberzug my-neovim ];
  cli-pkgs = builtins.concatLists [ de-clis media-clis system-clis system-tuis ];

  system-prog-langs = with pkgs; [ python3 nodejs ];
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

  misc-pkgs = builtins.concatLists [ archive-utils virt-utils kde-support system-prog-langs ];
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
    nixpkgs.config.allowUnfree = true;

    ### Packages ###
    environment.systemPackages = builtins.concatLists [
      gui-pkgs
      cli-pkgs
      misc-pkgs
    ] ++ (with pkgs;
      [
        texlive.combined.scheme-full
        syncthing
        direnv
      ]);

    # Font packages
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-serif
      fira-code
      fira-mono
      inconsolata-nerdfont
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

    ### Shell ###
    programs.zsh.enable = true;
    programs.zsh.enableCompletion = true;

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
          [alias]
          logline = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
        '';
        mode = "444";
      };
    };

    ### System GC ###
    nix.gc = {
      dates = "03:00";
      automatic = true;
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

      # xilinx udev rule
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "xilinx-dilligent-usb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
          text = ''
            ATTR{idVendor}=="1443", MODE:="666"
            ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
          '';
        })
        (pkgs.writeTextFile {
          name = "xilinx-pcusb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
          text = ''
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
            ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
          '';
        })
        (pkgs.writeTextFile {
          name = "xilinx-ftdi-usb-udev";
          destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
          text = ''
            ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
          '';
        })
      ];
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

