{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    kwallet-pam
    plasma-browser-integration
    libnotify
    libappindicator-gtk3
    plasma5Packages.kio-extras
    gnome.adwaita-icon-theme
    ark

    (plasma5Packages.bismuth.overrideAttrs (old: rec {
      version = "2.3.0";
      src = pkgs.fetchFromGitHub {
        owner = "Bismuth-Forge";
        repo = "bismuth";
        rev = "v${version}";
        sha256 = "sha256-b+dlBv1M4//oeCGM2qrQ3s6z2yLql6eQWNqId3JB3Z4=";
      };
      patches = [ ];
      cmakeFlags = [
        "-DUSE_TSC=OFF"
        "-DUSE_NPM=OFF"
      ];
    }))
    gnome.gnome-keyring

    # clipboard access from terminal
    wl-clipboard

    # logitech
    solaar

    xdotool
  ];

  # DE and touchpad
  services.xserver = {
    enable = true;
    xkbOptions = "altwin:swap_alt_win";
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
  };

  # Auto-unlock kwallet
  security.pam.services.kwallet =
    {
      name = "kwallet";
      enableKwallet = true;
    };

  # Audio
  hardware.pulseaudio.enable = true;
  sound.enable = true;

  # Printers
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Firmware
  hardware.enableRedistributableFirmware = true;

  # KDE Connect
  programs.kdeconnect.enable = true;
}
