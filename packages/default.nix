{ nixpkgs, utils, ... }:

utils.lib.eachDefaultSystem (system:
  let pkgs = nixpkgs.legacyPackages.${system};
  in
  with pkgs; {
    packages.wezterm = callPackage ./wezterm.nix {
      inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation;
    };
    packages.bismuth = import ./bismuth.nix {
      inherit pkgs; inherit (pkgs) lib;
    };
    packages.nodePackages = (import ./serverless-scriptable-plugin {
      inherit pkgs system;
      nodejs = pkgs.nodejs-14_x;
    });
  })
