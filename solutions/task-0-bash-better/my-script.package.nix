let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
in
# https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
pkgs.writeShellApplication {
  name = "my-arbitrary-upstream-name";

  runtimeInputs = [ 
    pkgs.cowsay 
    pkgs.kittysay
  ];

  text = builtins.readFile ./my-script.sh;
}