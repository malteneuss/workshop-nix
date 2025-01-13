let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  # native (Arm Mac) apps for your computer
  pkgs = import sources.nixpkgs {};
  # cross-compiled apps for Arm Linux (aarch64-linux)
  pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;
  # Hint: https://dev.to/misterio/how-to-package-a-rust-app-using-nix-3lh3
  # Official docs: https://nixos.org/manual/nixpkgs/stable/#rust
in pkgs.rustPlatform.buildRustPackage {
  name = "my-rust";
  version = "0.1.0";
  src = pkgs.lib.cleanSource ./.;
  cargoLock.lockFile = ./Cargo.lock;
}
