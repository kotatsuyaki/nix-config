{ hasGui ? false }: { pkgs, inputs, system, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.unstable.legacyPackages.${system}.quickemu
  ] ++ (if hasGui then [ pkgs.spice-gtk ] else [ ]);

  virtualisation = {
    spiceUSBRedirection.enable = true;
  };
}
