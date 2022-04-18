{ pkgs, ... }: {
  users.users.nixos = {
    shell = pkgs.zsh;
  };
}
