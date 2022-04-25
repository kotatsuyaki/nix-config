{ pkgs, lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gh-completion-zsh";
  version = "0.1";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/gh-completion-zsh}
    ${pkgs.github-cli}/bin/gh completion -s zsh > $out/share/zsh/site-functions/_gh

    echo "source $out/share/zsh/site-functions/_gh" > $out/share/zsh/plugins/gh-completion-zsh/gh-completion-zsh.plugin.zsh
  '';

  meta = with lib; {
    homepage = "";
    description = "Zsh completion for github-cli";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}

