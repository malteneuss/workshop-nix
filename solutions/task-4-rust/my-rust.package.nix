let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  # pkgs.pkgsCross.aarch64-multiplatform is for aarch64-linux
  # pkgsCross = pkgs.pkgsCross.aarch64-multiplatform;
  pkgs = import sources.nixpkgs {};
  # Hint: https://dev.to/misterio/how-to-package-a-rust-app-using-nix-3lh3
  # Official docs: https://nixos.org/manual/nixpkgs/stable/#rust
in pkgs.rustPlatform.buildRustPackage {
  name = "my-rust";
  version = "0.1.0";
  src = pkgs.lib.cleanSource ./.;
  cargoLock.lockFile = ./Cargo.lock;
}
