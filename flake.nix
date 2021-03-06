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
        { isPlasma ? false
        , isGnome ? false
        , extraModules ? [ ]
        , ...
        }: lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
            inherit (self) inputs;
            inherit system;
            inherit isPlasma;
            inherit isGnome;
          };
          modules =
            default-modules ++
            extraModules ++
            (lib.optionals (isPlasma || isGnome) gui-modules) ++
            (lib.optionals isPlasma [ ./de-modules/plasma.nix ]) ++
            (lib.optionals isGnome [ ./de-modules/gnome.nix ]);
        };
    in
    dev-shells // custom-pkgs // {
      nixosConfigurations.x13 = os-config {
        isPlasma = true;
        extraModules = [
          ./hardware/x13.nix
          ./opt-modules/fprintd.nix
          ./opt-modules/tlp.nix
          ./opt-modules/lxd.nix
        ];
      };

      nixosConfigurations.rx570 = os-config {
        isPlasma = true;
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
          ./opt-modules/vmware.nix
          (import ./services/frpc.nix {
            raw-config = ''
              [common]
              server_addr = lightsail.kotatsu.tk
              server_port = 7000

              [ssh]
              type = tcp
              local_ip = 127.0.0.1
              local_port = 22
              remote_port = 7001
            '';
          })
        ];
      };

      nixosConfigurations.rtx3070 = os-config {
        isPlasma = false;
        isGnome = true;
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
