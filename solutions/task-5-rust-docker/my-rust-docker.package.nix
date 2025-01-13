let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  # native (Arm Mac) apps for your computer
  pkgs = import sources.nixpkgs {};
  # cross-compiled apps for Arm Linux (aarch64-linux)
  pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;

  my-app = import ./my-rust.package.nix;
  # The same app but remote: https://github.com/malteneuss/rust-dummy-website
  # my-app = import (pkgs.fetchFromGitHub {
  #   owner = "malteneuss";
  #   repo = "rust-dummy-website";
  #   rev = "c621243f4e25d8da4884646cd12d0c795a0b8de7";
  #   sha256 = "sha256-p0WUtmE4/Lm2d9VafYedzuIJJPrcxAIaDiQLCwSNHT4=";
  # }) { inherit pkgs; };
  # "${my-app}/bin/subpackage"
  # Hint: https://nix.dev/tutorials/nixos/building-and-running-docker-images.html
in pkgs.dockerTools.buildImage {
  name = "my-rust-docker";
  tag = "latest";
# Quick and dirty
  config.Cmd = [ "${my-app}/bin/my-rust" ];
  # The same app but remote: https://github.com/malteneuss/rust-dummy-website
  # my-app = import (pkgs.fetchFromGitHub {
  #   owner = "malteneuss";
  #   repo = "rust-dummy-website";
  #   rev = "c621243f4e25d8da4884646cd12d0c795a0b8de7";
  #   sha256 = "sha256-p0WUtmE4/Lm2d9VafYedzuIJJPrcxAIaDiQLCwSNHT4=";
  # }) { inherit pkgs; };
  # "${my-app}/bin/subpackage"
  # copyToRoot = pkgs.buildEnv {
  #   name = "image-root";
  #   # What apps to copy to the image, and symlink inside /bin
  #   paths = [ my-app ];
  #   # Which folders to add $PATH
  #   pathsToLink = [ "/bin" ];
  # };

  # # from ${rust-app}/bin/my-rust
  # config.Cmd = [ "my-rust" ];
}
# Load into docker: docker load -i result
# Run: docker run --rm my-rust-docker:latest
