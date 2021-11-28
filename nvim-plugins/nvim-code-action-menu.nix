let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "weilbith";
    repo = "nvim-code-action-menu";
    rev = "d3d059082eff3eb081167f8a232b1bde54bb2bdb";
    sha256 = "0d7imklcz39ir53nr5kr0s826yqrwhrmr5p9iabs07hshyq3khgx";
    fetchSubmodules = false;
  }
