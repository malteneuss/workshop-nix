let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.stdenv.mkDerivation {
  pname = "my-script";
  version = "1.0.0";

  src = ./my-script.sh;

  buildInputs = [
    pkgs.cowsay
    pkgs.kittysay
    pkgs.makeWrapper
  ];

  unpackPhase = ":"; # Disable unzipping. There's nothing to unzip here.
  buildPhase = ":";  # Nothing to build.

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    chmod +x $out/bin/my-script
    wrapProgram $out/bin/my-script --prefix PATH : ${pkgs.cowsay}/bin:${pkgs.kittysay}/bin
  '';
}