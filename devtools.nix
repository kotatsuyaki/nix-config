{ pkgs, inputs, system, ... }: {
  environment.systemPackages = with pkgs; [
    # downloaders
    aria2
    curl
    wget

    # extractors
    p7zip
    unzip

    # lang
    python3Packages.ipython

    # tui apps
    tmux
    lazygit
    htop
    btop
    ranger
    ueberzug

    # cli tools
    zsh
    git
    ripgrep
    fd
    tealdeer
    fzf
    bat
    dnsutils

    # note taking
    inputs.personal.packages.${system}.nb
  ];

  # Set git commit --verbose as default
  environment.etc.gitconfig = {
    text = ''
      [commit]
      verbose = true
      [alias]
      logline = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    '';
    mode = "444";
  };
}
