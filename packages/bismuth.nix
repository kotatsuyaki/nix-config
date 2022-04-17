{ pkgs, lib }:

pkgs.libsForQt5.bismuth.overrideAttrs (old: rec {
  version = "3.1.1";
  src = pkgs.fetchFromGitHub {
    owner = "Bismuth-Forge";
    repo = old.pname;
    rev = "v${version}";
    sha256 = "sha256-SGeqTmU603gKlzCUJ6AMaG7++9JvMw5EpSATwJEqNq8=";
  };
  patches = [ ];
  cmakeFlags = [
    "-DUSE_TSC=OFF"
    "-DUSE_NPM=OFF"
  ];
})
