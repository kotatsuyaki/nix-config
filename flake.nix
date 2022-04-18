{
  description = "Flakes NixOS config for personal machines";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.utils.url = github:numtide/flake-utils;
  inputs.nixos-wsl.url = github:nix-community/NixOS-WSL;
  inputs.nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, unstable, utils, nixos-wsl }:
    let
      # Devshell for nix development
      dev-shells = utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              rnix-lsp
              nixpkgs-fmt
            ];
          };
        }
      );

      # Custom packages defined in this repo to be exposed
      custom-pkgs = import ./packages { inherit nixpkgs utils; };

      lib = nixpkgs.lib;
      # Non-recursively list files and dirs under `dir`
      list-files = dir: lib.mapAttrsToList
        (name: type: dir + "/${name}")
        (builtins.readDir dir);

      # Aggregated list of modules
      default-modules = list-files ./default-modules;
      gui-modules = list-files ./gui-modules;

      # Wrapper for nixosSystem
      os-config =
        { hasGui ? false
        , extraModules ? [ ]
        , ...
        }: lib.nixosSystem rec {
          system = "x86_64-linux";
          extraArgs = {
            inherit self;
            inherit (self) inputs;
            inherit system;
            inherit hasGui;
          };
          modules =
            default-modules ++
            extraModules ++
            (lib.optionals hasGui gui-modules);
        };
    in
    dev-shells // custom-pkgs // {
      nixosConfigurations.deltap = os-config {
        hasGui = false;
        extraModules = [
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          nixos-wsl.nixosModules.wsl
          ./opt-modules/wsl.nix
        ];
      };
    };
}
