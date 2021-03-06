{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "eastwood";
      plugins = [
        "fzf"
        "cp"
        "direnv"
        "lxd-completion-zsh"
        "gh-completion-zsh"
      ];
      customPkgs = [
        (pkgs.callPackage ./lxd-completion-zsh.nix { })
        (pkgs.callPackage ./gh-completion-zsh.nix { })
      ];
    };
    promptInit = builtins.readFile ./init.zsh;
  };
}
