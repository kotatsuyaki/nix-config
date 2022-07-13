{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    libinput.enable = true;
  };
  environment.systemPackages = with pkgs; with gnomeExtensions; [
    appindicator
    pop-shell
    system-monitor
    gnome.gnome-tweaks
  ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Audio
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = true;
  sound.enable = true;

  # Printers
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Firmware
  hardware.enableRedistributableFirmware = true;
}
