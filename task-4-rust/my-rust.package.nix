let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
  # Hint: https://dev.to/misterio/how-to-package-a-rust-app-using-nix-3lh3
  # Official docs: https://nixos.org/manual/nixpkgs/stable/#rust
in pkgs.rustPlatform.buildRustPackage ???
