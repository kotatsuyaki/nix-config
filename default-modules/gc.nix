{ pkgs, ... }: {
  nix.gc = {
    dates = "03:00";
    automatic = true;
  };
}
