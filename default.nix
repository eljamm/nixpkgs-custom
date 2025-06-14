let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  self ? import-flake {
    src = ./.;
  },
  sources ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${sources.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      system
      sources
      ;
  };
in
rec {
  formatter = import ./dev/formatter.nix args;

  shell = pkgs.mkShellNoCC {
    packages = [
      formatter
      pkgs.pinact # pin GH actions
    ];
  };

  packages = import ./pkgs args;
}
// args
