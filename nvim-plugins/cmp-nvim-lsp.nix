let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "hrsh7th";
    repo = "cmp-nvim-lsp";
    rev = "accbe6d97548d8d3471c04d512d36fa61d0e4be8";
    sha256 = "1dqx6yrd60x9ncjnpja87wv5zgnij7qmzbyh5xfyslk67c0i6mwm";
    fetchSubmodules = false;
  }
