let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "blackCauldron7";
    repo = "surround.nvim";
    rev = "a21c3eeee2f139d20694ff70135b3557cadece1c";
    sha256 = "0waa19nrrn8kqs27v5f73dananvxirx1cllc0172ymmvsgvv6hjk";
    fetchSubmodules = false;
  }
