let
  pkgs = import <nixos-unstable> {};
in
  pkgs.fetchFromGitHub {
    owner = "Mofiqul";
    repo = "vscode.nvim";
    rev = "00ff8f2a86e19f997f74bd8759552330b0c3b487";
    sha256 = "0gsmssjik8hwpm255k2wynyvfghz04pray3ljd6iykqg85gcyx0j";
    fetchSubmodules = false;
  }
