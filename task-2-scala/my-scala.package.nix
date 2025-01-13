let 
  sources = import ../pinned-nixpkgs/sources.nix;
  # use 3rd party for mkSbtDerivation builder
  # https://github.com/zaninime/sbt-derivation
  sbtOverlay = import "${sources.sbt-derivation}/overlay.nix";
  # Replace pkgs.jdk (default version 21) with a headless 23 version
  jdkOverlay = self: super: {
    jdk = super.jdk23_headless;
  };
  pkgs = import sources.nixpkgs {overlays = [jdkOverlay sbtOverlay];};
in
# Hint: https://github.com/zaninime/sbt-derivation#options
pkgs.mkSbtDerivation {
  
  # ???

  installPhase = ''
    mkdir -p $out/bin
    # A place to put our java jar(s)
    mkdir -p $out/share/java
    # Peek into sandboxed build directory
    # ls -ahl target/scala-3.3.3

    # ???

    makeWrapper ${pkgs.jdk}/bin/java $out/bin/my-scala \
      --add-flags "-cp \"$out/share/java/*\" Main"
  '';
}