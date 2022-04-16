{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lxd-completion-zsh";
  version = "20210323";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "lxd-completion-zsh";
    rev = "e82701cb2b8c42f63479bb1a34e4f78a7cb5b75c";
    sha256 = "sha256-n7XUxVw/vPli3ZA30JfhECbkfx0YQsdW4/z6D6XkwgY=";
  };

  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/lxd-completion-zsh}
    cp _* $out/share/zsh/site-functions

    # The upstream plugin file depends on the .zsh file being under the same directory
    # as the function files, so we write our own instead.
    # All it does is to source the two site functions.
    echo -e "source $out/share/zsh/site-functions/_lxc\nsource $out/share/zsh/site-functions/_lxd" > $out/share/zsh/plugins/lxd-completion-zsh/lxd-completion-zsh.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/endaaman/lxd-completion-zsh";
    description = "Zsh completion for lxc/lxd command of LXD ";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}

