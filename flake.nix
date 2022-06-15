{
  description = "Flakes NixOS config for personal machines";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, unstable, utils }:
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
          specialArgs = {
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
      nixosConfigurations.x13 = os-config {
        hasGui = true;
        extraModules = [
          ./hardware/x13.nix
          ./opt-modules/fprintd.nix
          ./opt-modules/tlp.nix
          ./opt-modules/lxd.nix
        ];
      };

      nixosConfigurations.rx570 = os-config {
        hasGui = true;
        extraModules = [
          ./hardware/rx570.nix
          ./opt-modules/waydroid.nix
          ./opt-modules/ios.nix
          ./opt-modules/steam.nix
          ./opt-modules/lxd.nix
          ./opt-modules/amdgpu-runpm-0.nix
          ./opt-modules/ipfs.nix
          ./opt-modules/avahi.nix
          ./opt-modules/k3s.nix
        ];
      };

      nixosConfigurations.rtx3070 = os-config {
        hasGui = false;
        extraModules = [
          ./hardware/rtx3070.nix
          ./opt-modules/nvidia.nix
          ./services/mcserver.nix
          (import ./services/autossh.nix {
            sessions = [
              {
                host = "vultr";
                user = "akitaki";
                pubkey = "/home/akitaki/.ssh/id_rsa";
                remote-port = 1314;
                local-port = 22;
                monitor-port = 25000;
              }
              {
                host = "dorm";
                user = "akitaki";
                pubkey = "/home/akitaki/.ssh/id_rsa";
                remote-port = 1314;
                local-port = 22;
                monitor-port = 26000;
              }
            ];
          })
        ];
      };
    };
}
