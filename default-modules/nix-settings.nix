{ pkgs, inputs, ... }: {
  nix = {
    # Enable flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Pin nixpkgs in registry
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.unstable.flake = inputs.unstable;


    settings = rec {
      # Personal binary cache
      trusted-substituters = [
        "https://kotatsuyaki.cachix.org"
        "https://nix-community.cachix.org"
      ];
      substituters = trusted-substituters;
      trusted-public-keys = [
        "kotatsuyaki.cachix.org-1:uX1H9hd4m+ZmqminrC2+oGp+1vIX95aHEuZ86Ja7/mE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
