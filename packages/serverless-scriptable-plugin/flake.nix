{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodePackages = pkgs.callPackage ./default.nix {
          inherit pkgs system;
          nodejs = pkgs.nodejs-14_x;
        };
      in
      {
        devShell = with pkgs; mkShell {
          buildInputs = [
            rnix-lsp
            nodePackages.serverless-scriptable-plugin
          ];
        };
      });
}

