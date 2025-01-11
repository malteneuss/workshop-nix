let 
  sources = import ../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.stdenv.mkDerivation {
  # Upstream name of what i am packaging
  name = "???";

  # Source code
  src = "???";
  unpackPhase = ":"; # Prevent mkDerivation from unzipping src.

  # "Compiler"/tools needed to build and run the package
  # You can find the Nix package names at https://search.nixos.org
  buildInputs = [
    # ???
  ];


  # Build script, resulting artifact $out 
  buildPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    # ???
  '';
}