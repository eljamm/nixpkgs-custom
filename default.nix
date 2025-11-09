{
  self ? import ./dev/import-flake.nix { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = {
      allowBroken = true;
    };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
lib.makeScope pkgs.newScope (
  self': with self'; {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;

    format = callPackage ./dev/formatter.nix { };
    custom-packages = callPackage ./pkgs { };
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        format.formatter
        pkgs.pinact # pin GH actions
      ];
    };

    flake = {
      inherit devShells;
      inherit (format) formatter;
      packages = lib.filterAttrs (n: v: lib.isDerivation v) custom-packages;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.packages;
      legacyPackages = custom-packages;
      overlays.default = final: prev: flake.packages;
    };
  }
)
