{ pkgs, inputs, ... }: {
  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
