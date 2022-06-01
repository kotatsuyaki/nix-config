{ pkgs, inputs, ... }:
let
  # Script for system-wide shorthand for `nix flake update --override-input nixpkgs ...`
  update-nix = pkgs.writeScriptBin "update-nix" ''
    #!/bin/sh
    ${pkgs.nix}/bin/nix flake update --override-input nixpkgs github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
  '';
in
{
  environment.systemPackages = [ update-nix ];
}
