let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  flake ? import-flake {
    src = ./.;
  },
  sources ? flake.inputs,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${sources.nixpkgs}/lib",
}:
rec {
  inherit
    lib
    pkgs
    system
    sources
    ;

  formatter = import ./dev/formatter.nix { inherit pkgs sources system; };

  shell = pkgs.mkShellNoCC {
    packages = [
      formatter
      pkgs.pinact # pin GH actions
    ];
  };
}
