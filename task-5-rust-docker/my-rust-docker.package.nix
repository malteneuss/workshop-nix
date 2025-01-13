let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  # native (Arm Mac) apps for your computer
  pkgs = import sources.nixpkgs {};
  # cross-compiled apps for Arm Linux (aarch64-linux)
  pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;
  my-app = import ./my-rust.package.nix;
  # Hint: https://nix.dev/tutorials/nixos/building-and-running-docker-images.html
in ???