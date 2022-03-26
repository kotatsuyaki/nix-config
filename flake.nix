{
  description = "Flakes NixOS config for personal machines";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, unstable, utils }:
    let
      devShells = utils.lib.eachDefaultSystem (system:
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
      osConfig =
        { hasGui ? false
        , extraModules ? [ ]
        , hasNvidia ? false
        , ...
        }: nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          extraArgs = {
            inherit (self) inputs;
            inherit system;
          };
          modules = [
            # Always enable unfree to ease management
            ({ nixpkgs.config.allowUnfree = true; })
            ./boot.nix
            ./network.nix
            ./gc.nix
            ./users.nix
            ./nix-settings.nix
            ./sshd.nix
            ./localize.nix

            # dev
            ./devtools.nix
            ./zsh
            ./neovim
            ./direnv.nix
            ./containers.nix

            # media
            ./misc.nix

            (import ./virt.nix { inherit hasGui; })
          ] ++ extraModules ++ (if hasGui then [
            # DE-specific stuff
            ./plasma.nix
            ./desktop-apps.nix
            ./fonts.nix
            ./sync.nix
            ./ime.nix
            ./media.nix
            ./mpd.nix
          ] else [ ]) ++ (if hasNvidia then [
            ./nvidia.nix
          ] else [ ]);
        };
    in
    devShells // {
      nixosConfigurations.x13 = osConfig {
        hasGui = true;
        extraModules = [
          ./hardware/x13.nix
          ./fprintd.nix
          ./tlp.nix
        ];
      };

      nixosConfigurations.rx570 = osConfig {
        hasGui = true;
        extraModules = [
          ./hardware/rx570.nix
          ./waydroid.nix
          ./ios.nix
          ./steam.nix
        ];
      };

      nixosConfigurations.rtx3070 = osConfig {
        hasGui = false;
        hasNvidia = true;
        extraModules = [
          ./hardware/rtx3070.nix
          ./services/mcserver.nix
        ];
      };

      # TODO: Remove this config after its retirement
      nixosConfigurations.t2micro = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        extraArgs = {
          inherit (self) inputs;
          inherit system;
        };
        modules = [
          ./ec2.nix
          ./nix-settings.nix
          ./users.nix
          ./ssh.nix

          # dev
          ./devtools.nix
          ./neovim
          ./misc.nix
          ./cgit
          ./zsh
          (self.inputs.nixpkgs + "/nixos/modules/virtualisation/amazon-image.nix")
        ];
      };
    };
}
