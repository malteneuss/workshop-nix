let 
  sources = import ../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
  my-app = import ./my-scala.package.nix;
  # Hint: https://nix.dev/tutorials/nixos/building-and-running-docker-images.html
in ???