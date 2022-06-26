{ pkgs, inputs, ... }: {
  nix = rec {
    # Enable flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Pin nixpkgs in registry
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.unstable.flake = inputs.unstable;

    # Personal binary cache
    trustedBinaryCaches = [
      "https://kotatsuyaki.cachix.org"
    ];
    binaryCaches = trustedBinaryCaches;
    binaryCachePublicKeys = [
      "kotatsuyaki.cachix.org-1:uX1H9hd4m+ZmqminrC2+oGp+1vIX95aHEuZ86Ja7/mE="
    ];

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
