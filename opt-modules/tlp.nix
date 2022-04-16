{ ... }: {
  # TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNER_ON_BAT = "powersave";
      CPU_SCALING_GOVERNER_ON_AC = "performance";
    };
  };
}
