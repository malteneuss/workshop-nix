let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.stdenv.mkDerivation {
  pname = "my-arbitrary-upstream-name";
  version = "1.0.0";

  src = ./my-script.sh;
  unpackPhase = ":";

  buildInputs = [
    pkgs.cowsay
    pkgs.kittysay
    pkgs.makeWrapper
  ];


  buildPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    chmod +x $out/bin/my-script
    wrapProgram $out/bin/my-script --prefix PATH : ${pkgs.cowsay}/bin:${pkgs.kittysay}/bin
  '';
}