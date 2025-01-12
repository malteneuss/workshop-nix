let 
  sources = import ../../pinned-nixpkgs/sources.nix;
  pkgs = import sources.nixpkgs {};
  my-app = import ./my-scala.package.nix;
  # Layers: https://grahamc.com/blog/nix-and-layered-docker-images/
  # Documentation: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
  # Hint: https://nix.dev/tutorials/nixos/building-and-running-docker-images.html
in pkgs.dockerTools.buildLayeredImage {
  name = "my-docker";
  tag = "latest";
  # we could add more apps to the image
  # copyToRoot = pkgs.buildEnv {
  #   name = "image-root";
  #   paths = [ my-app ];
  #   pathsToLink = [ "/bin" ];
  # };
  config.Cmd = [ "${my-app}/bin/my-scala" ];
}
# Load into docker: docker load -i result
# Run: docker run my-docker:latest
