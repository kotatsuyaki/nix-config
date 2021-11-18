let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "weilbith";
    repo = "nvim-code-action-menu";
    rev = "ca7cea159ae56bd95f44f28663ba62ba17959e7a";
    sha256 = "0pwm5kl3l53mwpn5piv16f4cbjgp5pwqfiz26dg8mlcnk0anp79w";
    fetchSubmodules = false;
  }
