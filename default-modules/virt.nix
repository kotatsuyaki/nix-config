{ pkgs, inputs, system, isPlasma, isGnome, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.unstable.legacyPackages.${system}.quickemu
  ] ++ (if (isPlasma || isGnome) then [ pkgs.spice-gtk ] else [ ]);

  virtualisation = {
    spiceUSBRedirection.enable = true;
  };
}
