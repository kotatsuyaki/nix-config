let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "blackCauldron7";
    repo = "surround.nvim";
    rev = "4018f676edfb37ea69b2ab01e80600f694d216b5";
    sha256 = "08g69xn5iqbvd8h24xb52h32lh3bfy42d6gqxr7d7siikzxgkif2";
    fetchSubmodules = false;
  }
