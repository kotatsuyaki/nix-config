{
  description = "Flakes NixOS config for personal machines";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.utils.url = github:numtide/flake-utils;
  inputs.personal.url = git+https://code.akitaki.tk/nix-packages.git;

  outputs = { self, nixpkgs, unstable, utils, personal }:
    let
      devShells = utils.lib.eachDefaultSystem
        (system:
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
    in
    devShells // {
      nixosConfigurations.x13 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        extraArgs = {
          inherit (self) inputs;
          inherit system;
        };
        modules = [
          ({
            nixpkgs = {
              config.allowUnfree = true;
            };
          })
          ./hardware/x13.nix
          ./boot.nix
          ./network.nix
          ./fprintd.nix
          ./gc.nix
          ./users.nix
          ./enable-flakes.nix

          # DE
          ./plasma.nix
          ./waydroid.nix
          ./desktop-apps.nix
          ./fonts.nix
          ./sync.nix
          ./localize.nix
          ./ios.nix

          # dev
          ./devtools.nix
          ./zsh
          ./neovim
          ./xilinx.nix
          ./direnv.nix

          # media
          ./media.nix
          ./misc.nix
          ./mpd.nix

          # laptop
          # ./ter-132n.nix
          ./tlp.nix
          ./virt.nix
        ];
      };

      nixosConfigurations.rx570 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        extraArgs = {
          inherit (self) inputs;
          inherit system;
        };
        modules = [
          ({
            nixpkgs = {
              config.allowUnfree = true;
            };
          })
          ({ inputs, ... }: {
            /* environment.systemPackages = [ personal ]; */
            /* environment.systemPackages = [ inputs.nb.outputs.packages.x86_64-linux.nb ]; */
          })
          ./waydroid.nix
          ./hardware/rx570.nix
          ./boot.nix
          ./network.nix
          ./gc.nix
          ./users.nix
          ./enable-flakes.nix
          ./ssh.nix
          ./haskell.nix

          # DE
          ./plasma.nix
          ./desktop-apps.nix
          ./fonts.nix
          ./sync.nix
          ./localize.nix
          ./ios.nix
          ./steam.nix

          # dev
          ./devtools.nix
          ./neovim
          ./zsh
          ./direnv.nix
          ./xilinx.nix

          # media
          ./media.nix
          ./misc.nix
          ./mpd.nix

          # laptop
          ./virt.nix
        ];
      };

      nixosConfigurations.rtx3070 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        extraArgs = {
          inherit (self) inputs;
          inherit system;
        };
        modules = [
          ({
            nixpkgs = {
              config.allowUnfree = true;
            };
          })
          ./hardware/rtx3070.nix
          ./nvidia.nix
          ./boot.nix
          ./network.nix
          ./gc.nix
          ./users.nix
          ./enable-flakes.nix
          ./ssh.nix

          # DE
          ./plasma.nix
          ./desktop-apps.nix
          ./fonts.nix
          ./sync.nix
          ./localize.nix

          # dev
          ./devtools.nix
          ./zsh
          ./neovim
          ./direnv.nix
          ./xilinx.nix

          # media
          ./media.nix
          ./misc.nix
          ./mpd.nix

          ./virt.nix
        ];
      };

      nixosConfigurations.t2micro = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        extraArgs = {
          inherit (self) inputs;
          inherit system;
        };
        modules = [
          ./ec2.nix
          ./enable-flakes.nix
          ./users.nix
          ./ssh.nix

          # dev
          ./devtools.nix
          ./neovim
          ./misc.nix
          ./cgit
          ./zsh
          (self.inputs.nixpkgs + "/nixos/modules/virtualisation/amazon-image.nix")
          ({ ... }: { networking.firewall.enable = false; })
        ];
      };
    };
}
