{
  description = "A flake for packaging fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    # git+ssh://git@git.example.com/User/repo.git if you're using private repos
    # cartograph = {
    #   url = "git+ssh://git@github.com/redyf/cartograph.git";
    #   flake = false;
    # };
    # monolisa = {
    #   url = "git+ssh://git@github.com/redyf/monolisa.git";
    #   flake = false;
    # };
    windows-fonts-cn = {
      url = "git+https://github.com/Moraxyc/Windows-Fonts-CN.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      # BerkeleyMono,
      # cartograph,
      # monolisa,
      # tx02,
      windows-fonts-cn,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          # lilex = pkgs.stdenv.mkDerivation rec {
          #   pname = "lilex";
          #   version = "2.600";
          #   src = pkgs.fetchurl {
          #     url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
          #     sha256 = "sha256-G8zm35aSiXrnGgYePSwLMBzwSnd9mfCinHZSG1qBH0w=";
          #   };
          #   buildInputs = [ pkgs.unzip ];
          #   unpackPhase = ''
          #     unzip -j $src
          #   '';
          #   installPhase = ''
          #     mkdir -p $out/share/fonts/truetype
          #     mv *.ttf $out/share/fonts/truetype/
          #   '';
          # };

          # monolisa = pkgs.stdenv.mkDerivation {
          #   pname = "Monolisa";
          #   version = "2.012";
          #   src = monolisa;
          #   installPhase = ''
          #     mkdir -p $out/share/fonts/truetype
          #     mv *.ttf $out/share/fonts/truetype/
          #   '';
          # };

          # cartograph = pkgs.stdenv.mkDerivation {
          #   pname = "CartographCF";
          #   version = "1.0";
          #   src = cartograph;
          #   installPhase = ''
          #     mkdir -p $out/share/fonts/opentype
          #     find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;
          #   '';
          # };
          windows-fonts-cn = pkgs.stdenv.mkDerivation {
            pname = "Windows-Fonts-CN";
            version = "1.0.0";
            src = windows-fonts-cn/Windows11/Fonts;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              find $src -type f -name '*.ttf' -exec cp {} $out/share/fonts/turetype/ \;
              find $src -type f -name '*.ttc' -exec cp {} $out/share/fonts/turetype/ \;
            '';
          };
        };

        defaultPackage = self.packages.${system}.windows-fonts-cn;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.fontconfig
            self.packages.${system}.monolisa
          ];
          shellHook = ''
            # Create fontconfig configuration
            export FONTCONFIG_FILE=${
              pkgs.makeFontsConf {
                fontDirectories = [ self.packages.${system}.monolisa ];
              }
            }
          '';
        };
      }
    );
}
