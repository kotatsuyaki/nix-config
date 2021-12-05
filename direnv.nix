{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    direnv
    nix-direnv
  ];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
  nixpkgs.overlays = [
    (self: super: {
      nix-direnv = super.nix-direnv.override {
        # Workaround found in
        # https://github.com/NixOS/nixpkgs/issues/147974
        enableFlakes = true;
      };
    })
  ];
}
