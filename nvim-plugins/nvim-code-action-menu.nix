let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "weilbith";
    repo = "nvim-code-action-menu";
    rev = "32a02caf1cb6d5d31167945a2df9d371d68b1009";
    sha256 = "1cpl29lz2c3fahrrz8lf9dccwy2iwdj4mn71xgn12kq3qarjijdv";
    fetchSubmodules = false;
  }
