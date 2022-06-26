{ pkgs, inputs, system, ... }: {
  environment.systemPackages = with pkgs; [
    # downloaders
    aria2
    curl
    wget

    # compression tools
    unzip
    zip
    archiver

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
    fx
    wuzz

    # vendor tools
    awscli2
    github-cli
    kubectl
    kubernetes-helm

    # rust stuff
    ripgrep # grep
    fd # find
    exa # ls
    tealdeer
    bat # cat
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
