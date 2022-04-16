{ pkgs, ... }: {
  users.users.akitaki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    shell = pkgs.zsh;
  };
}
