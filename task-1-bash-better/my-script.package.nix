let 
  sources = import ../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
# Hint: https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
pkgs.writeShellApplication {
  # ???
} 