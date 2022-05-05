{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
  ];
  nixpkgs.overlays = [
    (self: super: rec {
      ifuse = super.ifuse.overrideAttrs (old: {
        src = super.fetchFromGitHub {
          owner = "libimobiledevice";
          repo = "ifuse";
          rev = "6f5b8e410f9615b3369ca5eb5367745e13d83b92";
          sha256 = "sha256-KbuJLS2BWua9DnhLv2KtsQObin0PQwXQwEdgi3lSAPk=";
        };
      });

      libimobiledevice-glue = super.stdenv.mkDerivation rec {
        pname = "libimobiledevice-glue";
        version = "unstable-2022-04-22";

        src = super.fetchFromGitHub {
          owner = "libimobiledevice";
          repo = pname;
          rev = "c2e237ab5449b42461639c8e1eabbc61d0c386b7";
          sha256 = "sha256-WBe/iP96XlH1CNgyF2dKP617NDmwlzI37gHigsx1ANE=";
        };

        nativeBuildInputs = with super; [ autoreconfHook pkg-config ];
        buildInputs = with super; [ libplist ];

        meta = with super.lib; {
          description = " A library with common code used by libraries and tools around the libimobiledevice project ";
          homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
          license = licenses.lgpl21Plus;
          platforms = platforms.linux ++ platforms.darwin;
          maintainers = [ ];
        };
      };

      libusbmuxd = super.libusbmuxd.overrideAttrs (old: {
        src = super.fetchFromGitHub {
          owner = "libimobiledevice";
          repo = "libusbmuxd";
          rev = "a9a639d0102b9bbf30fd088e633c793316dbc873";
          sha256 = "sha256-ZiFKolBSLEcrHxdtEilNa97AlMm/oRf4EwRmhGiegj0=";
        };
        buildInputs = old.buildInputs ++ [ libimobiledevice-glue ];
        patchPhase = ''
          echo "2.0.3" >> .tarball-version
        '';
      });

      libimobiledevice = super.libimobiledevice.overrideAttrs (old: {
        src = super.fetchFromGitHub {
          owner = "libimobiledevice";
          repo = "libimobiledevice";
          rev = "c6f89deac00347faa187f2f5296e32840c4f26b4";
          sha256 = "sha256-W0kPF/9dch5UNimZfmnReNiZZqLWLxQ7qQK+4yJSeaI=";
        };
        buildInputs = [
          libimobiledevice-glue
          super.openssl
        ];
        patchPhase = ''
          echo "1.3.1" >> .tarball-version
        '';
      });
    })
  ];
}
