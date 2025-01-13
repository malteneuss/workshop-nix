let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  # use 3rd party sbt-derivation builder
  # https://github.com/zaninime/sbt-derivation
  sbtOverlay = import "${sources.sbt-derivation}/overlay.nix";
  # Replace pkgs.jdk (default version 21) with a headless 23 version
  jdkOverlay = self: super: {
    jdk = super.jdk23_headless;
  };
  # native (Arm Mac) apps for your computer
  pkgs = import sources.nixpkgs {overlays = [jdkOverlay sbtOverlay];};
  # native Arm Linux apps
  pkgsNativeArmLinux = import sources.nixpkgs {overlays = [jdkOverlay]; system = "aarch64-linux";};
in
# Source https://github.com/rgueldem/nix-scala-example
pkgs.mkSbtDerivation {
  pname = "my-scala";
  version = "1.0.0";

  src = pkgs.lib.cleanSource ./.;
  depsSha256 = "sha256-DXGqJCvcWhmNdr5o6wKwWYcAPwnmxapuRIsXbeCgzHU=";

  # mkSbtDerivation will automatically add pkgs.sbt and pkgs.jdk to buildInputs
  buildInputs = [pkgsNativeArmLinux.makeWrapper];

  # project/plugins.sbt mentions the sbt-assembly plugin
  # to help create a convenient fat jar ./target/scala-3.3.3/my-scala-assembly-1.0.0.jar
  buildPhase = "sbt assembly";

  # Combine our jar with a java runtime to create a runnable app
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java
    # ls -ahl target/scala-3.3.3

    cp target/scala-3.3.3/my-scala-assembly-1.0.0.jar $out/share/java

    makeWrapper ${pkgsNativeArmLinux.jdk}/bin/java $out/bin/my-scala \
      --add-flags "-cp \"$out/share/java/*\" Main"
  '';
}