let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "EdenEast";
    repo = "nightfox.nvim";
    rev = "6df32a7283f86c5ec7cf50a6996b39d3db5c1ac2";
    sha256 = "000vf833ajysbl5210a40kg9iq43mw77k7pnf4rg84pxjx49kvvd";
    fetchSubmodules = false;
  }
