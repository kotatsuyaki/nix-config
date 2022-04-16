{ nixpkgs, utils, ... }:

utils.lib.eachDefaultSystem (system:
  let pkgs = nixpkgs.legacyPackages.${system};
  in
  with pkgs; {
    packages.wezterm = callPackage ./wezterm.nix {
      inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation;
    };
  })
