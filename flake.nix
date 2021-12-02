{
  description = "Flakes NixOS config for personal machines";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  outputs = { self, nixpkgs }: {
    nixosConfigurations.x13 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
        ./desktop-apps.nix
        ./fonts.nix
        ./sync.nix
        ./localize.nix

        # dev
        ./devtools.nix
        ./neovim
        ./xilinx.nix

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

    nixosConfigurations.t2micro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      extraArgs = {
        inherit (self) inputs;
      };
      modules = [
        ./ec2.nix
        ./enable-flakes.nix
        ./users.nix

        # dev
        ./devtools.nix
        ./neovim
        ./misc.nix
        (self.inputs.nixpkgs + "/nixos/modules/virtualisation/amazon-image.nix")
        ({ ... }: { networking.firewall.enable = false; })
      ];
    };
  };
}
