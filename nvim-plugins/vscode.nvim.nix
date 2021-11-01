let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "Mofiqul";
    repo = "vscode.nvim";
    rev = "98f5a42d7ccb9fbe83d5b5f8dbfb43e41dd2f476";
    sha256 = "1k79zam9796k8zkqqy0ihhgsrxz376dgg7sd4l1x7li6z7frf98g";
    fetchSubmodules = false;
  }
