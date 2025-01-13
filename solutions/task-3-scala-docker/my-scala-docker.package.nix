let 
  # Layers: https://grahamc.com/blog/nix-and-layered-docker-images/
  # Documentation: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
  sources = import ../../pinned-nixpkgs/sources.nix;
  # native (Arm Mac) apps for your computer
  pkgs = import sources.nixpkgs {};
  my-app = import ./my-scala.package.nix;
  # cross-compiled apps for Arm Linux (aarch64-linux)
  # pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;
  # my-app = import ./my-scala-cross.package.nix;
in pkgs.dockerTools.buildImage {
  name = "my-scala-docker";
  tag = "latest";

  # Quick and dirty
  config.Cmd = [ "${my-app}/bin/my-scala" ];
  # Cleaner:
  # copyToRoot = pkgs.buildEnv {
  #   name = "image-root";
  #   # What apps to copy to the image, and symlink inside /bin
  #   paths = [ my-app ];
  #   # Which folders to add $PATH
  #   pathsToLink = [ "/bin" ];
  # };
  # from ${my-app}/bin/my-scala
  # config.Cmd = [ "my-scala" ];

  # config.Cmd = [ "${pkgsCross.hello}/bin/hello" ];
}
# Load into docker: docker load -i result
# Run: docker run --rm my-scala-docker:latest
