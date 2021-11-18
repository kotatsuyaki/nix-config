let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "hrsh7th";
    repo = "cmp-nvim-lsp";
    rev = "134117299ff9e34adde30a735cd8ca9cf8f3db81";
    sha256 = "1jnspl08ilz9ggkdddk0saxp3wzf05lll5msdfb4770q3bixddwc";
    fetchSubmodules = false;
  }
