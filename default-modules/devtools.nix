{ pkgs, inputs, system, ... }: {
  environment.systemPackages = with pkgs; [
    # downloaders
    aria2
    curl
    wget

    # extractors
    p7zip
    unzip
    archiver

    # lang
    python3Packages.ipython

    # tui apps
    tmux
    lazygit
    btop
    ranger
    ueberzug

    # cli tools
    zsh
    git
    dnsutils
    fzf

    # vendor tools
    awscli2
    github-cli

    # rust stuff
    ripgrep # grep
    fd # find
    exa # ls
    tealdeer
    bat
    dogdns # dig
    du-dust # du
    delta # diff
  ];

  # Set git commit --verbose as default
  environment.etc.gitconfig = {
    text = ''
      [commit]
      verbose = true
      [alias]
      logline = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit '';
    mode = "444";
  };
}
