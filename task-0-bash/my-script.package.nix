let 
  sources = import ../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.stdenv.mkDerivation {
  # Convention: Upstream name of what i am packaging
  pname = "???";
  version = "1.0.0";

  # Source code
  #src = ???;

  # Compiler/tools needed to build, install and run the package
  # You can find the Nix package names at https://search.nixos.org
  buildInputs = [
    pkgs.makeWrapper
    # ???
  ];

  unpackPhase = ":"; # Disable unzipping. There's nothing to unzip here.
  buildPhase = ":";  # Nothing to build.

  # Build script, resulting artifact $out 
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    # Try running ./result/my-script without "chmod". What's the problem?
    # chmod +x $out/bin/my-script
    # Try running ./result/my-script without this "wrapProgam". What's the problem?
    # wrapProgram $out/bin/my-script --prefix PATH : ${pkgs.???}/bin:${pkgs.???}/bin
  '';
}