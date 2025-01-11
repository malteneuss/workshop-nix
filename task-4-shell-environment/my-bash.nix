let 
  pkgs = import ../pinned-nixpkgs/sources.nix {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.bash
  ];
}